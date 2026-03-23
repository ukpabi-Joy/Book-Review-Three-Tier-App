output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.rds_jukpabi.endpoint
}

output "rds_host" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds_jukpabi.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds_jukpabi.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.rds_jukpabi.db_name
}

output "db_username" {
  description = "Database username"
  value       = aws_db_instance.rds_jukpabi.username
}
