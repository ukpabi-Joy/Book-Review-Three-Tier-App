variable "app_subnet_1_id" {
  description = "App subnet 1 ID from networking module"
  type        = string
}

variable "app_subnet_2_id" {
  description = "App subnet 2 ID from networking module"
  type        = string
}

variable "app_sg_id" {
  description = "App security group ID from security module"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "book-review-key"
}

variable "db_host" {
  description = "RDS database host"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
