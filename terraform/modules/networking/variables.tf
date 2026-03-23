variable "vpc_cidr" {
  description = "CIDR block for the VPC"
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
