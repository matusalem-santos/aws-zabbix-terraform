variable "install_dependencies" {
  description = "Saída do módulo de instalação de dependências, utilizado no depends_on de alguns recursos"
}

variable "instance_count" {
  description = "Número de instâncias que serão provisionadas"
  default     = 1
}

variable "name" {
  description = "Nome da instância"
}

variable "cliente" {
  description = "Nome do cliente"
}

variable "ansible_manual_zabbix" {
  description = "Forçar a execução do ansible zabbix"
}
variable "ami" {
  description = "ID da AMI usada para provisionar a instância"
}

variable "instance_type" {
  description = "Tipo (classe) da instância"
}

variable "vpc_id" {
  description = "ID da VPC onde a instância será provisionada"
}

variable "enable_ssm" {
  description = "Habilita o AWS SSM Session Manager. Essa é uma forma mais segura de conexão à instância do que a conexão por SSH"
  default     = true
}

variable "key_name" {
  description = "Nome do Key Pair a ser usado para a instância"
  default     = ""
}

variable "security_group_name" {
  description = "Nome do Security Group"
  default     = ""
}

variable "iam_instance_profile" {
  description = "Instance Profile do IAM vinculado à instância"
  default     = ""
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será provisionada"
  default     = ""
}

variable "subnet_ids" {
  description = "Lista com IDs das subnets onde a instância será provisionada"
  default     = []
}

variable "private_ip" {
  description = "IP privado da instância na VPC"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Vincula um IP público à instância"
  default     = false
}

variable "monitoring" {
  description = "Controla se a instância terá monitoramento detalhado"
  default     = false
}

variable "disable_api_termination" {
  description = "Controla a proteção de destruição (terminate) da instância"
  default     = false
}

variable "source_dest_check" {
  description = "Controla se o tráfego é roteado para a instância quando o endereço de destino não é o mesmo da instância"
  default     = true
}

variable "cpu_credits" {
  description = "Opção de créditos de CPU da instância (\"unlimited\" ou \"standard\")"
  default     = "standard"
}

variable "ebs_optimized" {
  description = "Controla se a instância será provisionada como EBS-optimized"
  default     = false
}

variable "root_block_device" {
  description = "Lista com maps de configuração do volume raiz da instância"
  type        = map(string)
}

variable "tags" {
  description = "Map de tags da instância e dos volumes"
  default     = {}
}

variable "ssh_user" {
  description = "User para conectar na instância via SSH"
  default     = ""
}

variable "ferramenta" {
  default = "grafana"
}

variable "client_name" {
  default = "cliente"
}

variable "environment" {
  default = "prd"
}

variable "ssh_public_key_path" {
  description = "Path to Read/Write SSH Public Key File (directory)"
  default     = "."
}

variable "zabbix_id" {
  description = "ID da maquina"
}
variable "generate_ssh_key" {
  default = "true"
}

variable "ssh_key_algorithm" {
  default = "RSA"
}

variable "private_key_extension" {
  default = ""
}

variable "public_key_extension" {
  default = ".pub"
}
variable "zabbix_security_groups" {
  description = "Security Groups do serviço Grafana"
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

variable "zabbix_agent_security_group" {
  description = "Security Group do Zabbix Agent"
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
