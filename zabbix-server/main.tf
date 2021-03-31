module "ec2" {
  source = "./ec2"

  name          = var.ec2_zabbix_name
  ami           = var.instance_ami
  instance_type = var.instance_type

  vpc_id                      = var.vpc_id
  subnet_id                   = var.ec2_subnet_id
  zabbix_security_groups      = var.zabbix_security_groups
  associate_public_ip_address = "true"
  rds                         = var.rds
  elastic_ip                  = var.elastic_ip

  root_block_device = {
    volume_type = "gp2"
    volume_size = var.zabbix_ebs_size
  }

  tags       = {
    Terraform = "True"
  }
  ssh_user   = var.ssh_user
  ferramenta = "zabbix"

  zabbix_version            = var.zabbix_version
  instalar_zabbix           = var.instalar_zabbix
  install_dependencies      = var.install_dependencies
  zabbix_id                 = module.ec2.id
  zabbix_record             = var.zabbix_record
  pass_admin                = var.pass_admin
  zbx_db_dns                = var.zbx_db_dns
  zbx_db_pass               = var.zbx_db_pass
  zabbix_agent_security_group  = var.zabbix_agent_security_group
  cliente                   = var.cliente
  ansible_manual_zabbix     = var.ansible_manual_zabbix
}

module "rds-aurora" {
  count = var.rds == "true" && var.rds_engine == "aurora" ? 1 : 0
  source                          = "terraform-aws-modules/rds-aurora/aws"

  name                            = "aurora-zabbixdb"
  port                            = 3306
  username                        = "zabbix"
  password                        = var.zbx_db_pass

  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.07.2"

  vpc_id                          = var.vpc_id
  subnets                         = var.rds_subnets

  replica_count                   = 1
  vpc_security_group_ids          = [var.rds_security_group_ids]
  create_security_group           = false
  instance_type                   = var.rds_instance_type
  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10

  db_parameter_group_name         = "default.aurora-mysql5.7"
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"

  tags                            = {
    Terraform   = "true"
  }
}

module "rds-mysql" {
  count = var.rds == "true" && var.rds_engine == "mysql" ? 1 : 0
  source = "./rds"

  rds        = var.rds
  identifier = "zabbixdb"

  engine                          = "mysql"
  engine_version                  = "8.0.20"
  instance_class                  = var.rds_instance_type
  allocated_storage               = var.rds_allocated_storage
  storage_encrypted               = true
  deletion_protection             = false
  multi_az                        = var.rds_multi_az
  performance_insights_enabled    = false
  vpc_id                          = var.vpc_id

  port     = 3306
  username = "zabbix"
  password = var.zbx_db_pass

  vpc_security_group_ids = [var.rds_security_group_ids]

  backup_window      = "04:30-05:00"
  maintenance_window = "sat:02:00-sat:04:00"

  # Parameter Group
  family = "mysql8.0"

  # Option Group
  major_engine_version = "8.0"

  # Subnet Group
  subnet_ids = var.rds_subnets

  tags = {
    Terraform   = "true"
  }
}
