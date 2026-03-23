output "app_ec2_1_id" {
  description = "App EC2 instance 1 ID"
  value       = aws_instance.app_ec2_1_jukpabi.id
}

output "app_ec2_2_id" {
  description = "App EC2 instance 2 ID"
  value       = aws_instance.app_ec2_2_jukpabi.id
}

output "app_ec2_1_private_ip" {
  description = "App EC2 instance 1 private IP"
  value       = aws_instance.app_ec2_1_jukpabi.private_ip
}

output "app_ec2_2_private_ip" {
  description = "App EC2 instance 2 private IP"
  value       = aws_instance.app_ec2_2_jukpabi.private_ip
}
