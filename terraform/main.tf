terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- Networking Module ---
# Must run first — all modules depend on its outputs
module "networking" {
  source            = "./modules/networking"
  vpc_cidr          = var.vpc_cidr
  web_subnet_1_cidr = var.web_subnet_1_cidr
  web_subnet_2_cidr = var.web_subnet_2_cidr
  app_subnet_1_cidr = var.app_subnet_1_cidr
  app_subnet_2_cidr = var.app_subnet_2_cidr
  db_subnet_1_cidr  = var.db_subnet_1_cidr
  db_subnet_2_cidr  = var.db_subnet_2_cidr
  az_1              = var.az_1
  az_2              = var.az_2
}

# --- Security Module ---
# Depends on VPC ID from networking
module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

# --- DB Tier Module ---
# Depends on db subnets and db security group
module "db_tier" {
  source                = "./modules/db_tier"
  db_subnet_1_id        = module.networking.db_subnet_1_id
  db_subnet_2_id        = module.networking.db_subnet_2_id
  db_sg_id              = module.security.db_sg_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class
}

# --- Web Tier Module ---
# Depends on web subnets and web security group
module "web_tier" {
  source          = "./modules/web_tier"
  web_subnet_1_id = module.networking.web_subnet_1_id
  web_subnet_2_id = module.networking.web_subnet_2_id
  web_sg_id       = module.security.web_sg_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

# --- App Tier Module ---
# Depends on app subnets, app security group and db outputs
module "app_tier" {
  source          = "./modules/app_tier"
  app_subnet_1_id = module.networking.app_subnet_1_id
  app_subnet_2_id = module.networking.app_subnet_2_id
  app_sg_id       = module.security.app_sg_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  db_host         = module.db_tier.rds_host
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
}

# --- Load Balancer Module ---
# Depends on all tier outputs
module "load_balancer" {
  source          = "./modules/load_balancer"
  vpc_id          = module.networking.vpc_id
  web_subnet_1_id = module.networking.web_subnet_1_id
  web_subnet_2_id = module.networking.web_subnet_2_id
  app_subnet_1_id = module.networking.app_subnet_1_id
  app_subnet_2_id = module.networking.app_subnet_2_id
  alb_sg_id       = module.security.alb_sg_id
  app_sg_id       = module.security.app_sg_id
  web_ec2_1_id    = module.web_tier.web_ec2_1_id
  web_ec2_2_id    = module.web_tier.web_ec2_2_id
  app_ec2_1_id    = module.app_tier.app_ec2_1_id
  app_ec2_2_id    = module.app_tier.app_ec2_2_id
}
