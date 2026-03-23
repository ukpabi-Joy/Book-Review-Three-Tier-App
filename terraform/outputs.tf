# ==========================================
# APPLICATION ACCESS
# ==========================================

output "public_alb_dns" {
  description = "Public ALB DNS — access the app here"
  value       = module.load_balancer.public_alb_dns
}

output "internal_alb_dns" {
  description = "Internal ALB DNS"
  value       = module.load_balancer.internal_alb_dns
}

# ==========================================
# WEB TIER
# ==========================================

output "web_ec2_1_public_ip" {
  description = "Web EC2 1 public IP"
  value       = module.web_tier.web_ec2_1_public_ip
}

output "web_ec2_2_public_ip" {
  description = "Web EC2 2 public IP"
  value       = module.web_tier.web_ec2_2_public_ip
}

output "web_ec2_1_private_ip" {
  description = "Web EC2 1 private IP"
  value       = module.web_tier.web_ec2_1_private_ip
}

output "web_ec2_2_private_ip" {
  description = "Web EC2 2 private IP"
  value       = module.web_tier.web_ec2_2_private_ip
}

# ==========================================
# APP TIER
# ==========================================

output "app_ec2_1_private_ip" {
  description = "App EC2 1 private IP"
  value       = module.app_tier.app_ec2_1_private_ip
}

output "app_ec2_2_private_ip" {
  description = "App EC2 2 private IP"
  value       = module.app_tier.app_ec2_2_private_ip
}

# ==========================================
# DATABASE
# ==========================================

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.db_tier.rds_endpoint
}

output "rds_host" {
  description = "RDS hostname"
  value       = module.db_tier.rds_host
}

output "db_name" {
  description = "Database name"
  value       = module.db_tier.db_name
}
