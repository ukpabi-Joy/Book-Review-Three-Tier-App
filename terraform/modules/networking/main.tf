# --- VPC ---
resource "aws_vpc" "vpc_jukpabi" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "vpc-jukpabi" }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "igw_jukpabi" {
  vpc_id = aws_vpc.vpc_jukpabi.id

  tags = { Name = "igw-jukpabi" }
}

# --- Web Subnet 1 (Public - AZ1) ---
resource "aws_subnet" "web_subnet_1_jukpabi" {
  vpc_id                  = aws_vpc.vpc_jukpabi.id
  cidr_block              = var.web_subnet_1_cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = { Name = "web-subnet-1-jukpabi" }
}

# --- Web Subnet 2 (Public - AZ2) ---
resource "aws_subnet" "web_subnet_2_jukpabi" {
  vpc_id                  = aws_vpc.vpc_jukpabi.id
  cidr_block              = var.web_subnet_2_cidr
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = { Name = "web-subnet-2-jukpabi" }
}

# --- App Subnet 1 (Private - AZ1) ---
resource "aws_subnet" "app_subnet_1_jukpabi" {
  vpc_id            = aws_vpc.vpc_jukpabi.id
  cidr_block        = var.app_subnet_1_cidr
  availability_zone = var.az_1

  tags = { Name = "app-subnet-1-jukpabi" }
}

# --- App Subnet 2 (Private - AZ2) ---
resource "aws_subnet" "app_subnet_2_jukpabi" {
  vpc_id            = aws_vpc.vpc_jukpabi.id
  cidr_block        = var.app_subnet_2_cidr
  availability_zone = var.az_2

  tags = { Name = "app-subnet-2-jukpabi" }
}

# --- DB Subnet 1 (Private - AZ1) ---
resource "aws_subnet" "db_subnet_1_jukpabi" {
  vpc_id            = aws_vpc.vpc_jukpabi.id
  cidr_block        = var.db_subnet_1_cidr
  availability_zone = var.az_1

  tags = { Name = "db-subnet-1-jukpabi" }
}

# --- DB Subnet 2 (Private - AZ2) ---
resource "aws_subnet" "db_subnet_2_jukpabi" {
  vpc_id            = aws_vpc.vpc_jukpabi.id
  cidr_block        = var.db_subnet_2_cidr
  availability_zone = var.az_2

  tags = { Name = "db-subnet-2-jukpabi" }
}

# --- Public Route Table ---
resource "aws_route_table" "public_rt_jukpabi" {
  vpc_id = aws_vpc.vpc_jukpabi.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_jukpabi.id
  }

  tags = { Name = "public-rt-jukpabi" }
}

# --- Associate Web Subnet 1 with Public Route Table ---
resource "aws_route_table_association" "web_rt_assoc_1_jukpabi" {
  subnet_id      = aws_subnet.web_subnet_1_jukpabi.id
  route_table_id = aws_route_table.public_rt_jukpabi.id
}

# --- Associate Web Subnet 2 with Public Route Table ---
resource "aws_route_table_association" "web_rt_assoc_2_jukpabi" {
  subnet_id      = aws_subnet.web_subnet_2_jukpabi.id
  route_table_id = aws_route_table.public_rt_jukpabi.id
}

# --- Private Route Table ---
resource "aws_route_table" "private_rt_jukpabi" {
  vpc_id = aws_vpc.vpc_jukpabi.id

  tags = { Name = "private-rt-jukpabi" }
}

# --- Associate App Subnet 1 with Private Route Table ---
resource "aws_route_table_association" "app_rt_assoc_1_jukpabi" {
  subnet_id      = aws_subnet.app_subnet_1_jukpabi.id
  route_table_id = aws_route_table.private_rt_jukpabi.id
}

# --- Associate App Subnet 2 with Private Route Table ---
resource "aws_route_table_association" "app_rt_assoc_2_jukpabi" {
  subnet_id      = aws_subnet.app_subnet_2_jukpabi.id
  route_table_id = aws_route_table.private_rt_jukpabi.id
}

# --- Associate DB Subnet 1 with Private Route Table ---
resource "aws_route_table_association" "db_rt_assoc_1_jukpabi" {
  subnet_id      = aws_subnet.db_subnet_1_jukpabi.id
  route_table_id = aws_route_table.private_rt_jukpabi.id
}

# --- Associate DB Subnet 2 with Private Route Table ---
resource "aws_route_table_association" "db_rt_assoc_2_jukpabi" {
  subnet_id      = aws_subnet.db_subnet_2_jukpabi.id
  route_table_id = aws_route_table.private_rt_jukpabi.id
}
