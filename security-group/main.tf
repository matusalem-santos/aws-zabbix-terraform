module "sg_zabbix_server" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name                = "sg_zabbix_server"
  description         = "Security Group do Zabbix Server"
  vpc_id              = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 10051
      to_port     = 10051
      protocol    = "tcp"
      description = "Porta do Zabbix server pro agent enviar dados"
      cidr_blocks = var.vpc_cidr_block
    }
  ]
  egress_rules        = ["all-all"]
}

module "sg_zabbix_agent" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name                = "sg_zabbix_agent"
  description         = "Security Group Zabbix Agent"
  vpc_id              = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH para o zabbix server"
      source_security_group_id  = module.sg_zabbix_server.this_security_group_id
    },
    {
      from_port   = 10050
      to_port     = 10050
      protocol    = "tcp"
      description = "Porta do agent para o Zabbix server coletar"
      source_security_group_id  = module.sg_zabbix_server.this_security_group_id
    }
  ]
  egress_rules        = ["all-all"] 
}

module "sg_zabbix_db" {
  count = var.rds == "true" ? 1 : 0
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name                = "sg_zabbix_db"
  description         = "Security Group do Banco do Zabbix"
  vpc_id              = var.vpc_id
  ingress_with_source_security_group_id = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Acesso ao banco"
      source_security_group_id = module.sg_zabbix_server.this_security_group_id
    }
  ]
  egress_rules        = ["all-all"] 
}