output "zabbix_record_name" {
  description = "Nome do dominio criado"
  value       = aws_route53_record.zabbix.name
}
