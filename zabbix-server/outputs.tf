output "zabbix_private_ip" {
  description = "Lista dos IPs privados das instâncias"
  value       = module.ec2.private_ip
}

output "aurora_db_dns" {
  description = "DNS do Banco RDS"
  value = module.rds-aurora.*.this_rds_cluster_endpoint
}

output "mysql_db_dns" {
  description = "DNS do Banco RDS"
  value = module.rds-mysql.*.address
}

output "zabbix_elastic_ip" {
  description = "IP publico da maquina"
  value = module.ec2.elastic_ip
}

output "zabbix_pem" {
  description = "Chave privada da instância"
  value       = module.ec2.private_key_pem
}

output "zabbix_pem_name" {
  description = "Chave privada da instância"
  value       = module.ec2.zabbix_pem_name
}