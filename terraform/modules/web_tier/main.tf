# --- SSH Key Pair ---
resource "aws_key_pair" "web_keypair_jukpabi" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# --- Web EC2 Instance 1 (AZ1) ---
resource "aws_instance" "web_ec2_1_jukpabi" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = var.instance_type
  subnet_id                   = var.web_subnet_1_id
  vpc_security_group_ids      = [var.web_sg_id]
  key_name                    = aws_key_pair.web_keypair_jukpabi.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs git nginx
    systemctl start nginx
    systemctl enable nginx
    echo "Web EC2 1 ready" > /tmp/status.txt
  EOF

  tags = {
    Name = "web-ec2-1-jukpabi"
    tier = "web"
    az   = "us-east-1a"
  }
}

# --- Web EC2 Instance 2 (AZ2) ---
resource "aws_instance" "web_ec2_2_jukpabi" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = var.instance_type
  subnet_id                   = var.web_subnet_2_id
  vpc_security_group_ids      = [var.web_sg_id]
  key_name                    = aws_key_pair.web_keypair_jukpabi.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs git nginx
    systemctl start nginx
    systemctl enable nginx
    echo "Web EC2 2 ready" > /tmp/status.txt
  EOF

  tags = {
    Name = "web-ec2-2-jukpabi"
    tier = "web"
    az   = "us-east-1b"
  }
}
