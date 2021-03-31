provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

terraform {
  # Versão do terraform definida no Terraform Cloud
  required_version = "~> 0.14.3"
  # Informações do Projeto no Terraform Cloud
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "monit"

    workspaces {
      name = var.workspace
    }
  }
}

# Módulo que instala as dependencias necessarias na maquina 
# que realiza a execução do Terraform 
module "install-dependencies" {
  source = "./install-dependencies"
}

# Módulo que provisiona o Zabbix Server
module "zabbix-server" {
  source = "./zabbix-server"

  # Nome da maquina do Zabbix
  ec2_zabbix_name              = var.ec2_zabbix_name
  # Variavel que torna o módulo install_dependencies uma dependencia do modulo zabbix-server
  install_dependencies         = module.install-dependencies.id
  # Criar a pem com nome do cliente
  cliente                      = var.workspace
  # VPC onde sera realizado o provisionamento da stack de monitoramento
  vpc_id                       = var.vpc_id
  # Permitir a instalação do zabbix server
  instalar_zabbix              = lower(var.instalar_zabbix)
  # Permitir a instalação do Grafana
  instalar_grafana             = lower(var.instalar_grafana)
  # Versão do zabbix server disponível [4.4 ou 5.0]
  zabbix_version               = var.zabbix_version
  # Forçar a execução do ansible zabbix
  ansible_manual_zabbix        = var.ansible_manual_zabbix
  # Tipo da instancia que sera provisionada
  instance_type                = var.instance_type
  # Tamanho do disco EBS para a maquina do Zabbix
  zabbix_ebs_size              = var.zabbix_ebs_size
  # ID da Subnet onde a instancia sera provisionada
  ec2_subnet_id                = var.ec2_subnet_id
  # Definir a ami da instancia
  instance_ami                 = var.instance_ami
  # User para conectar na instância via SSH
  ssh_user                     = var.ssh_user
  # Instância ser provisionada com Elastic IP
  elastic_ip                   = lower(var.elastic_ip)
  # ID das Subnets onde o rds sera provisionado
  rds_subnets                  = split(",", var.rds_subnets)
  # Tipo da instancia para o rds que sera provisionada
  rds_instance_type            = var.rds_instance_type
  # DNS provisionado para o ansible colocá-lo na instalação do agent
  zabbix_record                = module.route53.zabbix_record_name
  # Grupo de Segurança do Zabbix Sever
  zabbix_security_groups       = [module.security-group.sg_zabbix_server_id]
  # Grupo de Segurança para as maquinas que serão monitoradas
  zabbix_agent_security_group  = module.security-group.sg_zabbix_agent_id
  # Senha do Usuario Admin
  pass_admin                   = var.pass_admin
  # DNS do Banco RDS caso a variavel "rds" seja definida como "true"
  zbx_db_dns                   = join(", ", flatten([module.zabbix-server.aurora_db_dns, module.zabbix-server.mysql_db_dns] ))
  # Senha do Banco do zabbix seja local ou por RDS
  zbx_db_pass                  = var.zbx_db_pass
  # Definir se o RDS vai ser multi az
  rds_multi_az                 = lower(var.rds_multi_az)
  # Definir o tamanho do storage do RDS Mysql
  rds_allocated_storage        = var.rds_allocated_storage
  # Definir se o RDS é Mysql ou Aurora
  rds_engine                   = lower(var.rds_engine)
  # Variavel que define se o banco do zabbix vai ser Local ou no RDS
  rds                          = lower(var.rds)
  # Grupo de Segurança do RDS caso a variavel "rds" seja definida como "true"
  rds_security_group_ids       = lower(var.rds) == "true" ? join(", ", module.security-group.sg_zabbix_db_id) : ""
}

# Módulo com todos os Grupos de Segurança
module "security-group" {
  source = "./security-group"
  # VPC onde sera realizado o provisionamento da stack de monitoramento
  vpc_id = var.vpc_id
  # Variavel que define se o banco do zabbix vai ser Local ou no RDS
  rds    = lower(var.rds)
  vpc_cidr_block = var.vpc_cidr_block
}

# Módulo para criação de Hosted Zone e Record apontando para o IP privado do Zabbix
module "route53" {
  source        = "./route53"
  # VPC onde sera realizado o provisionamento da stack de monitoramento
  vpc_id        = var.vpc_id
  # IP privado do Zabbix Server
  private_ip    = module.zabbix-server.zabbix_private_ip
  # Nome para o Hosted Zone provisionado
  hosted_name   = var.hosted_name
}

module "s3" {
  source          = "./s3"
  zabbix_pem      = module.zabbix-server.zabbix_pem
  zabbix_pem_name = module.zabbix-server.zabbix_pem_name
}