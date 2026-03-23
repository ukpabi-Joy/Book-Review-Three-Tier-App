# --- App EC2 Instance 1 (AZ1) ---
# NO public IP — private only!
resource "aws_instance" "app_ec2_1_jukpabi" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = var.instance_type
  subnet_id                   = var.app_subnet_1_id
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs git
    npm install -g pm2
    cat > /etc/app.env <<ENVFILE
    DB_HOST=${var.db_host}
    DB_NAME=${var.db_name}
    DB_USER=${var.db_username}
    DB_PASS=${var.db_password}
    PORT=3001
    NODE_ENV=production
    ENVFILE
    echo "App EC2 1 ready" > /tmp/status.txt
  EOF

  tags = {
    Name = "app-ec2-1-jukpabi"
    tier = "app"
    az   = "us-east-1a"
  }
}

# --- App EC2 Instance 2 (AZ2) ---
# NO public IP — private only!
resource "aws_instance" "app_ec2_2_jukpabi" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = var.instance_type
  subnet_id                   = var.app_subnet_2_id
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs git
    npm install -g pm2
    cat > /etc/app.env <<ENVFILE
    DB_HOST=${var.db_host}
    DB_NAME=${var.db_name}
    DB_USER=${var.db_username}
    DB_PASS=${var.db_password}
    PORT=3001
    NODE_ENV=production
    ENVFILE
    echo "App EC2 2 ready" > /tmp/status.txt
  EOF

  tags = {
    Name = "app-ec2-2-jukpabi"
    tier = "app"
    az   = "us-east-1b"
  }
}
