# ==========================================
# GLOBAL VARIABLES
# ==========================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# ==========================================
# NETWORK VARIABLES
# ==========================================

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_1_cidr" {
  description = "Web subnet 1 CIDR — AZ1 Public"
  type        = string
  default     = "10.0.1.0/24"
}

variable "web_subnet_2_cidr" {
  description = "Web subnet 2 CIDR — AZ2 Public"
  type        = string
  default     = "10.0.2.0/24"
}

variable "app_subnet_1_cidr" {
  description = "App subnet 1 CIDR — AZ1 Private"
  type        = string
  default     = "10.0.3.0/24"
}

variable "app_subnet_2_cidr" {
  description = "App subnet 2 CIDR — AZ2 Private"
  type        = string
  default     = "10.0.4.0/24"
}

variable "db_subnet_1_cidr" {
  description = "DB subnet 1 CIDR — AZ1 Private"
  type        = string
  default     = "10.0.5.0/24"
}

variable "db_subnet_2_cidr" {
  description = "DB subnet 2 CIDR — AZ2 Private"
  type        = string
  default     = "10.0.6.0/24"
}

variable "az_1" {
  description = "Availability Zone 1"
  type        = string
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Availability Zone 2"
  type        = string
  default     = "us-east-1b"
}

# ==========================================
# EC2 VARIABLES
# ==========================================

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

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/book-review-key.pub"
}

# ==========================================
# DATABASE VARIABLES
# ==========================================

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "bookreview"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database admin password — set in terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
