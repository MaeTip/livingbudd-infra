output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds.address
  sensitive   = true
}

output "rds_username" {
  description = "The master username for the database"
  value       = aws_db_instance.rds.username
  sensitive   = true
}

output "rds_password" {
  description = "The database password"
  value       = aws_db_instance.rds.password
  sensitive   = true
}

output "rds_name" {
  description = "The database name"
  value       = aws_db_instance.rds.db_name
}

output "rds_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.rds.endpoint
}
