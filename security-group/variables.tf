variable "vpc_id" {
  description = "ID da VPC onde o recurso será provisionado"
}

variable "rds" {
  description = "Verificar se o zabbix sera provisionado com rds ou não"
}

variable "vpc_cidr_block" {
  description = "Cidr block da VPC onde o recurso será provisionado"
}