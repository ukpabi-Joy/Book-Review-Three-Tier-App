output "web_sg_id" {
  description = "Web tier security group ID"
  value       = aws_security_group.web_sg_jukpabi.id
}

output "app_sg_id" {
  description = "App tier security group ID"
  value       = aws_security_group.app_sg_jukpabi.id
}

output "db_sg_id" {
  description = "DB tier security group ID"
  value       = aws_security_group.db_sg_jukpabi.id
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb_sg_jukpabi.id
}
