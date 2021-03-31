resource "aws_db_instance" "main" {
  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.license_model

  name     = var.name
  username = var.username
  password = var.password
  port     = var.port

  replicate_source_db = var.replicate_source_db

  snapshot_identifier = var.snapshot_identifier

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name != "" ? var.db_subnet_group_name : element(coalescelist(aws_db_subnet_group.main.*.id, list("")), 0)
  parameter_group_name   = var.parameter_group_name != "" ? var.parameter_group_name : element(coalescelist(aws_db_parameter_group.main.*.id, list("")), 0)
  option_group_name      = var.option_group_name != "" ? var.option_group_name : element(coalescelist(aws_db_option_group.main.*.id, list("")), 0)

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  iops                = var.iops
  publicly_accessible = var.publicly_accessible

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window

  character_set_name = var.character_set_name

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection = var.deletion_protection

  performance_insights_enabled = var.performance_insights_enabled
  

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# Subnet Group
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_db_subnet_group" "main" {
  count = var.db_subnet_group_name == "" ? 1 : 0

  name_prefix = "${var.identifier}-"
  subnet_ids  = flatten([var.subnet_ids])
  description = "[TF] Subnet group for ${var.identifier}"

  tags = var.tags

}

# ----------------------------------------------------------------------------------------------------------------------
# Parameter Group
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_db_parameter_group" "main" {
  count = var.parameter_group_name == "" ? 1 : 0

  name_prefix = "${var.identifier}-"
  family      = var.family
  description = "[TF] Parameter group for ${var.identifier}"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

}

# ----------------------------------------------------------------------------------------------------------------------
# Option Group
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_db_option_group" "main" {
  count = var.option_group_name == "" ? 1 : 0

  name_prefix              = "${var.identifier}-"
  option_group_description = "[TF] Option group for ${var.identifier}"
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

}
