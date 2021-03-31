output "zabbix_private_ip" {
  description = "Lista dos IPs privados das instâncias"
  value       = module.zabbix-server.zabbix_private_ip
}

output "aurora_db_dns" {
  description = "DNS do Banco RDS Aurora"
  value = module.zabbix-server.aurora_db_dns
}

output "mysql_db_dns" {
  description = "DNS do Banco RDS Mysql"
  value = module.zabbix-server.mysql_db_dns
}

output "zabbix_elastic_ip" {
  description = "IP publico da maquina"
  value = module.zabbix-server.zabbix_elastic_ip
}

output "zabbix_pem" {
  description = "Pem do Zabbix"
  value = module.zabbix-server.zabbix_pem
}

output "bucket_name" {
  description = "Bucket que armazena a pem do Zabbix"
  value = module.s3.s3_bucket_id
}