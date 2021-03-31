output "sg_zabbix_server_id" {
  description = "The ID of the security group"
  value       = module.sg_zabbix_server.this_security_group_id
}

output "sg_zabbix_agent_id" {
  description = "The ID of the security group"
  value       = module.sg_zabbix_agent.this_security_group_id
}

output "sg_zabbix_db_id" {
  description = "The ID of the security group"
  value       = module.sg_zabbix_db.*.this_security_group_id
}