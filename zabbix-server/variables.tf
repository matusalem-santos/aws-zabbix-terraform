variable "install_dependencies" {
  description = "Saída do módulo de instalação de dependências, utilizado no depends_on de alguns recursos"
}
variable "vpc_id" {
  description = "ID da VPC onde o recurso será provisionado"
}
variable "instance_type" {
  description = "Tipo da instancia que sera provisionada"
}

variable "cliente" {
  description = "Nome do cliente"
}

variable "ec2_zabbix_name" {
  description = "Nome da maquina do Zabbix Server"
}

variable "zabbix_ebs_size" {
  description = "Tamanho do disco EBS para a maquina do Zabbix"
}

variable "ansible_manual_zabbix" {
  description = "Forçar a execução do ansible zabbix"
}

variable "rds_instance_type" {
  description = "Tipo da instancia para o rds que sera provisionada"
}

variable "rds_multi_az" {
  description = "Definir se o RDS vai ser multi az"
}

variable "ec2_subnet_id" {
  description = "ID da Subnet onde a instancia sera provisionada"
}

variable "rds_subnets" {
  description = "ID das Subnets onde o rds sera provisionada"
}

variable "zabbix_security_groups" {
  description = "Security Groups do Serviço Zabbix"
}

variable "zabbix_agent_security_group" {
  description = "Security Group do Zabbix Agent"
}

variable "zabbix_record" {
  description = "Nome do dominio criado"
}

variable "pass_admin" {
  description = "Senha do Admin"
}

variable "rds" {
  description = "Verificar se o zabbix sera provisionado com rds ou não"
}

variable "zbx_db_dns" {
  description = "dns do banco se for RDS"
}

variable "zbx_db_pass" {
  description = "Senha do banco do Zabbix"
}

variable "rds_security_group_ids" {
  description = "Verificar se o zabbix sera provisionado com rds ou não"
}

variable "rds_allocated_storage" {
  description = "Definir o tamanho do storage do RDS Mysql"
}

variable "rds_engine" {
  description = "Definir se o RDS é Mysql ou Aurora"
}

variable "instance_ami" {
  default     = "ami-02eac2c0129f6376b"
  description = "Definir a ami da instancia, variável mantida pelo Terraform Cloud"
}

variable "ssh_user" {
  description = "User para conectar na instância via SSH"
}

variable "elastic_ip" {
  description = "Instância ser provisionada com Elastic IP, variável mantida pelo Terraform Cloud"
}

variable "instalar_zabbix" {
  description = "Permitir a instalação do zabbix server"
}


variable "zabbix_version" {
  description = "Versão do zabbix server disponível [4.4 ou 5.0]"
}
