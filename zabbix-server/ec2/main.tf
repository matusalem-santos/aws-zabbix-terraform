# ----------------------------------------------------------------------------------------------------------------------
# Key-pars
# ----------------------------------------------------------------------------------------------------------------------
locals {
  public_key_filename  = "${var.ssh_public_key_path}/${var.ferramenta}-${var.cliente}${var.public_key_extension}"
  private_key_filename = "${var.ssh_public_key_path}/${var.ferramenta}-${var.cliente}${var.private_key_extension}"
}

resource "tls_private_key" "default" {
  count     = var.generate_ssh_key == "true" ? 1 : 0
  algorithm = var.ssh_key_algorithm
}

resource "aws_key_pair" "generated" {
  count      = var.generate_ssh_key == "true" ? 1 : 0
  key_name   = "${var.ferramenta}-${var.cliente}"
  public_key = tls_private_key.default[count.index].public_key_openssh
}

resource "local_file" "public_key_openssh" {
  count    = var.generate_ssh_key == "true" ? 1 : 0
  content  = tls_private_key.default[count.index].public_key_openssh
  filename = local.public_key_filename
}

resource "local_file" "private_key_pem" {
  count    = var.generate_ssh_key == "true" ? 1 : 0
  content  = tls_private_key.default[count.index].private_key_pem
  filename = local.private_key_filename
}
# ----------------------------------------------------------------------------------------------------------------------
# EC2
# ----------------------------------------------------------------------------------------------------------------------
data "template_file" "userdata" {
  template = "${path.module}/user-data.tpl"
}

resource "aws_instance" "main" {
  count = var.instance_count

  ami                  = var.ami
  instance_type        = var.instance_type
  user_data            = <<EOT
#!/bin/bash
sudo yum install -y curl
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl restart amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
EOT
  key_name             = aws_key_pair.generated[count.index].key_name
  iam_instance_profile = data.aws_iam_instance_profile.being_used.name

  subnet_id = element(distinct(compact(concat(list(var.subnet_id), var.subnet_ids))), count.index)

  private_ip                  = var.private_ip
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = flatten([var.zabbix_security_groups])


  monitoring              = var.monitoring
  disable_api_termination = var.disable_api_termination
  source_dest_check       = var.source_dest_check

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  ebs_optimized = var.ebs_optimized
  root_block_device {
    volume_type = var.root_block_device["volume_type"]
    volume_size = var.root_block_device["volume_size"]
  }
  tags = merge(
    map("Name", var.instance_count > 1 ? format("%s-%d", var.name, count.index + 1) : var.name),
    var.tags
  )

  volume_tags = merge(
    map("Name", var.instance_count > 1 ? format("%s-%d", var.name, count.index + 1) : var.name),
    var.tags
  )
}

# Elastic IP atachado na maquina
resource "aws_eip" "lb" {
  count = var.elastic_ip == "true" ? 1 : 0

  instance = aws_instance.main[count.index].id
  vpc      = true
}
# Select user specified instance profile or the default one created (see below)
data "aws_iam_instance_profile" "being_used" {
  name = var.iam_instance_profile != "" ? var.iam_instance_profile : join("", aws_iam_instance_profile.default.*.id)
}

# ----------------------------------------------------------------------------------------------------------------------
# IAM
# ----------------------------------------------------------------------------------------------------------------------

# Default instance profile, role and policy document if instance profile is not specified
resource "aws_iam_instance_profile" "default" {
  count = 1

  role = aws_iam_role.default[count.index].name
}

resource "aws_iam_role" "default" {
  count              = 1
  assume_role_policy = data.aws_iam_policy_document.allow_ec2_to_assume_role.json
}

data "aws_iam_policy_document" "allow_ec2_to_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name_prefix        = "EC2ZabbixAccess"
  description = "Permições que a maquina do zabbix precisa para monitorar"

  policy = file("${path.module}/policy_files/ec2_zabbix_access.json")

}

# ----------------------------------------------------------------------------------------------------------------------
# SSM ACCESS
# ----------------------------------------------------------------------------------------------------------------------

# Attaches default Amazon policy for SSM, EC2FullAccess, CloudWatchReadOnlyAccess
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  for_each = toset(
  ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",  
  "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ])

  role       = data.aws_iam_instance_profile.being_used.role_name
  policy_arn = each.key
}
resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = data.aws_iam_instance_profile.being_used.role_name
  policy_arn = aws_iam_policy.policy.id
}
# ----------------------------------------------------------------------------------------------------------------------
# ANSIBLE
# ----------------------------------------------------------------------------------------------------------------------

# Executa o script "dirhash.sh" e verifica se o diretório passado teve alguma alteração
# Usado para Trigar os recursos que executam o ansible na maquina
data "external" "dirhash_ansible_zabbix" {
  program = ["bash", "${path.module}/dirhash.sh"]
  for_each = {
    ansible-zabbix            = "${path.module}/ansible-zabbix"
  }

  query = {
    directory = each.value
  }
}

# Executa o ansible que realiza a instalação do Zabbix Server
resource "null_resource" "zabbix" {
  count = var.instalar_zabbix == "true" ? 1 : 0

  triggers = {
    ansible_zabbix_md5 = data.external.dirhash_ansible_zabbix["ansible-zabbix"].result["checksum"]
    ansible_manual_zabbix     = var.ansible_manual_zabbix
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = file("${path.module}/ansible.sh")

    environment = var.rds == "true" ? {
      ZABBIX_VERSION          = var.zabbix_version
      PRIVATE_SSH_KEY         = file(aws_key_pair.generated[count.index].key_name)
      EC2_ZABBIX_ID           = var.zabbix_id
      ANSIBLE_DIR             = "${path.module}/ansible-zabbix"
      PASS_ADMIN              = var.pass_admin
      ZBX_DB_PASS             = var.zbx_db_pass
      ZBX_DB_DNS              = var.zbx_db_dns
      SSH_USER                = var.ssh_user
    } : {
      ZABBIX_VERSION          = var.zabbix_version
      PRIVATE_SSH_KEY         = file(aws_key_pair.generated[count.index].key_name)
      EC2_ZABBIX_ID           = var.zabbix_id
      ANSIBLE_DIR             = "${path.module}/ansible-zabbix"
      PASS_ADMIN              = var.pass_admin
      ZBX_DB_PASS             = var.zbx_db_pass
      ZBX_DB_DNS              = "localhost"
      SSH_USER                = var.ssh_user
    }

  }

  depends_on = [
    var.install_dependencies,
    aws_instance.main
  ]
}
