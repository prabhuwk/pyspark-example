output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.aaj-postgres-rds-cdc-01.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.aaj-postgres-rds-cdc-01.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.aaj-postgres-rds-cdc-01.username
  sensitive   = true
}