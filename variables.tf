variable "AWS_DEFAULT_REGION" {
  type        = string
  description = "Região onde os recursos serão provisionados, variável mantida pelo Terraform Cloud"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "Secret key da conta que sera provisionado o ambiente, variável mantida pelo Terraform Cloud"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "Access key da conta que sera provisionado o ambiente, variável mantida pelo Terraform Cloud"
}

variable "workspace" {
  type        = string
  description = "Workspace no Terraform Cloud, variável mantida pelo Terraform Cloud"
}

variable "ec2_zabbix_name" {
  default     = "Zabbix Server"
  type        = string
  description = "Nome da maquina do Zabbix Server, variável mantida pelo Terraform Cloud"
}

variable "ansible_manual_zabbix" {
  default = ""
  description = "Forçar a execução do ansible zabbix"
}

variable "zabbix_ebs_size" {
  default     = "50"
  type        = string
  description = "Tamanho do disco EBS para a maquina do Zabbix, variável mantida pelo Terraform Cloud"
}


variable "vpc_id" {
  type        = string
  description = "VPC onde sera realizado o provisionamento da stack de monitoramento, variável mantida pelo Terraform Cloud"
}

variable "rds" {
  default     = "false"
  type        = string
  description = "Variavel que define se o banco do zabbix vai ser Local ou no RDS, variável mantida pelo Terraform Cloud"
}

variable "pass_admin" {
  type        = string
  description = "Senha do Usuario Admin, variável mantida pelo Terraform Cloud"
}

variable "zbx_db_pass" {
  type        = string
  description = "Senha do Banco do zabbix seja local ou por RDS, variável mantida pelo Terraform Cloud"
}

variable "hosted_name" {
  type        = string
  default     = "monitoramento.vpc"
  description = "Nome para o Hosted Zone provisionado, variável mantida pelo Terraform Cloud"
}

variable "instance_type" {
  default     = "t3.medium"
  description = "Tipo da instancia que sera provisionada, variável mantida pelo Terraform Cloud"
}

variable "rds_subnets" {
  default     = ""
  description = "ID das Subnets onde o rds sera provisionado, mínimo 3 subnets, variável mantida pelo Terraform Cloud"
}

variable "ec2_subnet_id" {
  description = "ID da Subnet onde a instancia sera provisionada, variável mantida pelo Terraform Cloud"
}

variable "rds_instance_type" {
  default     = "db.t2.medium"
  description = "Tipo da instancia para o rds que sera provisionada, variável mantida pelo Terraform Cloud"
}

variable "vpc_cidr_block" {
  description = "Cidr block da VPC onde o recurso será provisionado, variável mantida pelo Terraform Cloud"
}

variable "rds_multi_az" {
  default     = "false"
  description = "Definir se o RDS Mysql vai ser multi az, variável mantida pelo Terraform Cloud"
}

variable "rds_allocated_storage" {
  default     = "50"
  description = "Definir o tamanho do storage do RDS Mysql, variável mantida pelo Terraform Cloud"
}

variable "rds_engine" {
  default     = ""
  description = "Definir se o RDS é Mysql ou Aurora, variável mantida pelo Terraform Cloud"
}

variable "instance_ami" {
  default     = "ami-02eac2c0129f6376b"
  description = "Definir a ami da instancia, variável mantida pelo Terraform Cloud"
}

variable "ssh_user" {
  description = "User para conectar na instância via SSH, variável mantida pelo Terraform Cloud"
  default     = "centos"
}

variable "elastic_ip" {
  description = "Instância ser provisionada com Elastic IP, variável mantida pelo Terraform Cloud"
  default     = "true"
}

variable "instalar_zabbix" {
  description = "Permitir a instalação do zabbix server, variável mantida pelo Terraform Cloud"
  default     = "true"
}

variable "zabbix_version" {
  description = "Versão do zabbix server disponível [4.4 ou 5.0], variável mantida pelo Terraform Cloud"
  default     = "5.0"
}
