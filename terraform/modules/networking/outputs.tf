output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc_jukpabi.id
}

output "web_subnet_1_id" {
  description = "Web subnet 1 ID"
  value       = aws_subnet.web_subnet_1_jukpabi.id
}

output "web_subnet_2_id" {
  description = "Web subnet 2 ID"
  value       = aws_subnet.web_subnet_2_jukpabi.id
}

output "app_subnet_1_id" {
  description = "App subnet 1 ID"
  value       = aws_subnet.app_subnet_1_jukpabi.id
}

output "app_subnet_2_id" {
  description = "App subnet 2 ID"
  value       = aws_subnet.app_subnet_2_jukpabi.id
}

output "db_subnet_1_id" {
  description = "DB subnet 1 ID"
  value       = aws_subnet.db_subnet_1_jukpabi.id
}

output "db_subnet_2_id" {
  description = "DB subnet 2 ID"
  value       = aws_subnet.db_subnet_2_jukpabi.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gw_jukpabi.id
}

output "nat_gateway_public_ip" {
  description = "NAT Gateway public Elastic IP"
  value       = aws_eip.nat_eip_jukpabi.public_ip
}
