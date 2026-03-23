variable "db_subnet_1_id" {
  description = "DB subnet 1 ID from networking module"
  type        = string
}

variable "db_subnet_2_id" {
  description = "DB subnet 2 ID from networking module"
  type        = string
}

variable "db_sg_id" {
  description = "DB security group ID from security module"
  type        = string
}

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
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "allocated_storage" {
  description = "Storage allocated in GB"
  type        = number
  default     = 20
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}
