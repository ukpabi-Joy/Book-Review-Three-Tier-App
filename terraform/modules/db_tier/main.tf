# --- DB Subnet Group ---
# RDS requires a subnet group spanning at least 2 AZs
resource "aws_db_subnet_group" "db_subnet_group_jukpabi" {
  name       = "db-subnet-group-jukpabi"
  subnet_ids = [var.db_subnet_1_id, var.db_subnet_2_id]

  tags = { Name = "db-subnet-group-jukpabi" }
}

# --- RDS MySQL Instance (Multi-AZ) ---
resource "aws_db_instance" "rds_jukpabi" {
  identifier              = "rds-jukpabi"
  engine                  = "mysql"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group_jukpabi.name
  vpc_security_group_ids  = [var.db_sg_id]
  publicly_accessible     = false
  multi_az                = true
  backup_retention_period = var.backup_retention_days
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "rds-jukpabi"
    tier = "database"
  }
}
