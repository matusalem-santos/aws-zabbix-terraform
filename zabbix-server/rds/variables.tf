variable "identifier" {
  description = "Nome da instância RDS"
}

variable "engine" {
  description = "Engine da instância"
}

variable "engine_version" {
  description = "Versão da engine da instância"
}

variable "instance_class" {
  description = "Tipo (classe) da instância"
}

variable "allocated_storage" {
  description = "Espaço em disco (em GB) alocado para a instância"
}

variable "storage_type" {
  description = "Tipo do storage da instância"
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Habilita encriptação do storage da instância"
  default     = false
}

variable "kms_key_id" {
  description = "ARN da chave KMS para encriptação do storage; caso não seja definida, será usada a chave KMS padrão da conta"
  default     = ""
}

variable "license_model" {
  description = "Modelo de licença da instância; opcional mas obrigatório dependendo da engine da instância (ex: Oracle SE1)"
  default     = ""
}

variable "name" {
  description = "Nome do banco de dados; se omitido, nenhum banco será criado inicialmente"
  default     = ""
}

variable "username" {
  description = "Nome do usuário master do banco"
}

variable "password" {
  description = "Senha do usuário master do banco"
}

variable "port" {
  description = "Porta de conexão à instância"
}

variable "replicate_source_db" {
  description = "Define se a instância será uma réplica; para habilitar, utilize o identificador de outra instância existente"
  default     = ""
}

variable "snapshot_identifier" {
  description = "Define se a instância será criada a partir de um snapshot; para habilitar, utilize o ID de um snapshot existente"
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "Lista com IDs de security groups que serão vinculados à instância"
  default     = []
}

variable "db_subnet_group_name" {
  description = "Nome de um subnet group a ser usado para a instância; se omitido, `subnet_ids` deve ser definida e um novo será criado"
  default     = ""
}

variable "subnet_ids" {
  description = "Lista com IDs de subnets a serem vinculadas ao subnet group criado. Obrigatória se `db_subnet_group_name` for omitida"
  default     = []
}

variable "parameter_group_name" {
  description = "Nome de um parameter group a ser usado para a instância; se omitido, um novo será criado"
  default     = ""
}

variable "family" {
  description = "Família utilizada para a criação do parameter group"
  default     = ""
}

variable "parameters" {
  description = "Lista de maps com Parameters do parameter group"
  default     = []
}

variable "option_group_name" {
  description = "Nome de um option group a ser usado para a instância; se omitido, um novo será criado"
  default     = ""
}

variable "options" {
  description = "Lista de maps com Options do option group"
  default     = []
}

variable "major_engine_version" {
  description = "Versão maior da engine da instância. Obrigatória caso `option_group_name` seja omitida"
  default     = ""
}

variable "availability_zone" {
  description = "AZ onde a instância será provisionada"
  default     = ""
}

variable "multi_az" {
  description = "Habilita provisionamento multi-AZ da instância"
  default     = false
}

variable "performance_insights_enabled" {
  description = "Habilitar performance insights na instância"
  default     = false
}

variable "iops" {
  description = "Quantidade de IOPS provisionados para a instância; se definida, implica que `storage_type` será `io1`"
  default     = 0
}

variable "publicly_accessible" {
  description = "Define se a instância será acessível publicamente"
  default     = false
}

variable "monitoring_interval" {
  description = "Intervalo (em segundos) entre os pontos de coletagem de métricas do Enhanced Monitoring; se definida como 0, desativa métricas do Enhanced Monitoring. Valores válidos: 0, 1, 5, 10, 15, 30, 60"
  default     = 0
}

variable "monitoring_role_arn" {
  description = "ARN de uma role do IAM que permite o RDS enviar métricas do Enhanced Monitoring para o CloudWatch Logs. Obrigatória se `monitoring_interval` for diferente de 0"
  default     = ""
}

variable "allow_major_version_upgrade" {
  description = "Habilita atualizações da versão maior da engine utilizada"
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Habilita atualizações automáticas da versão menor da engine durante a janela de manutenção"
  default     = true
}

variable "apply_immediately" {
  description = "Habilita a aplicação imediata de modificações da instância; se desativada, as modificações serão aplicadas somente durante a janela de manutenção"
  default     = false
}

variable "maintenance_window" {
  description = "Janela de manutenção da instância. Formato: `ddd:hh24:mi-ddd:hh24:mi`. Exemplo: `sat:03:00-sat:05:00`"
}

variable "skip_final_snapshot" {
  description = "Define se uma snapshot final do banco será criada antes da remoção da instância. Se ativada, nenhuma snapshot será criada. Se desativada, uma snapshot será criada usando o valor de `final_snapshot_identifier`"
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "Habilita a cópia das tags da instância para os snapshots"
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Nome da snapshot final criada antes da remoção da instância"
  default     = false
}

variable "backup_retention_period" {
  description = "Número de dias de retenção dos backups"
  default     = 3
}

variable "backup_window" {
  description = "Intervalo de horário diário (em UTC) durante o qual os backups automáticos serão criados; não pode sobrepor `maintenance_window`. Exemplo: `05:30-06:00`"
}

variable "character_set_name" {
  description = "Nome (opcional) do character set usado em instâncias Oracle; após definido, não pode ser alterado"
  default     = ""
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Lista de tipos de logs a serem exportados para o CloudWatch logs. Se omitida, nenhum log será exportado. Valores válidos: alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)"
  default     = []
}

variable "deletion_protection" {
  description = "Habilita a proteção de remoção da instância"
  default     = false
}

variable "tags" {
  description = "Map de tags comuns a todos os recursos"
  default     = {}
}

variable "timeouts" {
  description = "Timeouts (opcionais) de gerenciamento do Terraform; permite intervalos customizados de gerenciamento da instância RDS"
  default     = {}
}
variable "vpc_id" {
  description = "ID da VPC onde a instância será provisionada"
}

variable "rds" {
  description = "Verificar se o zabbix sera provisionado com rds ou não"
}
