output "address" {
  description = "Hostname da instância"
  value       = aws_db_instance.main.address
}

output "arn" {
  description = "ARN da instância"
  value       = aws_db_instance.main.arn
}

output "availability_zone" {
  description = "AZ da instância"
  value       = aws_db_instance.main.availability_zone
}

output "engine" {
  description = "Engine da instância"
  value       = aws_db_instance.main.engine
}

output "engine_version" {
  description = "Versão da engine da instância"
  value       = aws_db_instance.main.engine_version
}

output "id" {
  description = "ID da instância"
  value       = aws_db_instance.main.id
}

output "name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.main.name
}

output "username" {
  description = "Nome do usuário master do banco"
  value       = aws_db_instance.main.username
}

output "port" {
  description = "Porta de conexão à instância"
  value       = aws_db_instance.main.port
}

output "multi_az" {
  description = "Status de multi-AZ da instância"
  value       = aws_db_instance.main.multi_az
}

output "maintenance_window" {
  description = "Janela de manutenção"
  value       = aws_db_instance.main.maintenance_window
}

output "backup_retention_period" {
  description = "Número de dias de retenção dos backups"
  value       = aws_db_instance.main.backup_retention_period
}

output "backup_window" {
  description = "Intervalo de horário diário (em UTC) durante o qual os backups automáticos são criados"
  value       = aws_db_instance.main.backup_window
}

output "resource_id" {
  description = "Resource ID da instância"
  value       = aws_db_instance.main.resource_id
}

output "option_group_name" {
  description = "Nome do option group vinculado à instância"
  value       = aws_db_instance.main.option_group_name
}
