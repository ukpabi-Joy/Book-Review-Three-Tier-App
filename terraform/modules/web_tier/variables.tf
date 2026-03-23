variable "web_subnet_1_id" {
  description = "Web subnet 1 ID from networking module"
  type        = string
}

variable "web_subnet_2_id" {
  description = "Web subnet 2 ID from networking module"
  type        = string
}

variable "web_sg_id" {
  description = "Web security group ID from security module"
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

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/book-review-key.pub"
}

variable "app_backend_url" {
  description = "Internal ALB URL for backend API"
  type        = string
  default     = "http://internal-alb-jukpabi"
}
