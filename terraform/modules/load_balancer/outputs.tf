output "public_alb_dns" {
  description = "Public ALB DNS name — access app here"
  value       = aws_lb.public_alb_jukpabi.dns_name
}

output "public_alb_arn" {
  description = "Public ALB ARN"
  value       = aws_lb.public_alb_jukpabi.arn
}

output "internal_alb_dns" {
  description = "Internal ALB DNS name"
  value       = aws_lb.internal_alb_jukpabi.dns_name
}

output "internal_alb_arn" {
  description = "Internal ALB ARN"
  value       = aws_lb.internal_alb_jukpabi.arn
}

output "web_target_group_arn" {
  description = "Web tier target group ARN"
  value       = aws_lb_target_group.web_tg_jukpabi.arn
}

output "app_target_group_arn" {
  description = "App tier target group ARN"
  value       = aws_lb_target_group.app_tg_jukpabi.arn
}
