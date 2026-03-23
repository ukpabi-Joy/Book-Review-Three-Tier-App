output "web_ec2_1_id" {
  description = "Web EC2 instance 1 ID"
  value       = aws_instance.web_ec2_1_jukpabi.id
}

output "web_ec2_2_id" {
  description = "Web EC2 instance 2 ID"
  value       = aws_instance.web_ec2_2_jukpabi.id
}

output "web_ec2_1_public_ip" {
  description = "Web EC2 instance 1 public IP"
  value       = aws_instance.web_ec2_1_jukpabi.public_ip
}

output "web_ec2_2_public_ip" {
  description = "Web EC2 instance 2 public IP"
  value       = aws_instance.web_ec2_2_jukpabi.public_ip
}

output "web_ec2_1_private_ip" {
  description = "Web EC2 instance 1 private IP"
  value       = aws_instance.web_ec2_1_jukpabi.private_ip
}

output "web_ec2_2_private_ip" {
  description = "Web EC2 instance 2 private IP"
  value       = aws_instance.web_ec2_2_jukpabi.private_ip
}
