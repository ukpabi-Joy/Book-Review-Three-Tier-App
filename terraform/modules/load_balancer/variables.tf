variable "vpc_id" {
  description = "VPC ID from networking module"
  type        = string
}

variable "web_subnet_1_id" {
  description = "Web subnet 1 ID for public ALB"
  type        = string
}

variable "web_subnet_2_id" {
  description = "Web subnet 2 ID for public ALB"
  type        = string
}

variable "app_subnet_1_id" {
  description = "App subnet 1 ID for internal ALB"
  type        = string
}

variable "app_subnet_2_id" {
  description = "App subnet 2 ID for internal ALB"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}

variable "app_sg_id" {
  description = "App security group ID for internal ALB"
  type        = string
}

variable "web_ec2_1_id" {
  description = "Web EC2 instance 1 ID"
  type        = string
}

variable "web_ec2_2_id" {
  description = "Web EC2 instance 2 ID"
  type        = string
}

variable "app_ec2_1_id" {
  description = "App EC2 instance 1 ID"
  type        = string
}

variable "app_ec2_2_id" {
  description = "App EC2 instance 2 ID"
  type        = string
}
