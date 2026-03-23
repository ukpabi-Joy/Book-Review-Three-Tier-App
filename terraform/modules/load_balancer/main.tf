# ==========================================
# PUBLIC ALB
# Routes internet traffic to Web Tier
# ==========================================

# --- Public ALB ---
resource "aws_lb" "public_alb_jukpabi" {
  name               = "public-alb-jukpabi"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.web_subnet_1_id, var.web_subnet_2_id]

  tags = {
    Name = "public-alb-jukpabi"
    role = "public-alb"
  }
}

# --- Target Group for Web Tier ---
resource "aws_lb_target_group" "web_tg_jukpabi" {
  name     = "web-tg-jukpabi"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = { Name = "web-tg-jukpabi" }
}

# --- Register Web EC2 1 with Target Group ---
resource "aws_lb_target_group_attachment" "web_tg_attach_1_jukpabi" {
  target_group_arn = aws_lb_target_group.web_tg_jukpabi.arn
  target_id        = var.web_ec2_1_id
  port             = 80
}

# --- Register Web EC2 2 with Target Group ---
resource "aws_lb_target_group_attachment" "web_tg_attach_2_jukpabi" {
  target_group_arn = aws_lb_target_group.web_tg_jukpabi.arn
  target_id        = var.web_ec2_2_id
  port             = 80
}

# --- Public ALB Listener on port 80 ---
resource "aws_lb_listener" "public_alb_listener_jukpabi" {
  load_balancer_arn = aws_lb.public_alb_jukpabi.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg_jukpabi.arn
  }
}

# ==========================================
# INTERNAL ALB
# Routes Web Tier traffic to App Tier
# Private — no public access
# ==========================================

# --- Internal ALB ---
resource "aws_lb" "internal_alb_jukpabi" {
  name               = "internal-alb-jukpabi"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.app_sg_id]
  subnets            = [var.app_subnet_1_id, var.app_subnet_2_id]

  tags = {
    Name = "internal-alb-jukpabi"
    role = "internal-alb"
  }
}

# --- Target Group for App Tier ---
resource "aws_lb_target_group" "app_tg_jukpabi" {
  name     = "app-tg-jukpabi"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = { Name = "app-tg-jukpabi" }
}

# --- Register App EC2 1 with Target Group ---
resource "aws_lb_target_group_attachment" "app_tg_attach_1_jukpabi" {
  target_group_arn = aws_lb_target_group.app_tg_jukpabi.arn
  target_id        = var.app_ec2_1_id
  port             = 3001
}

# --- Register App EC2 2 with Target Group ---
resource "aws_lb_target_group_attachment" "app_tg_attach_2_jukpabi" {
  target_group_arn = aws_lb_target_group.app_tg_jukpabi.arn
  target_id        = var.app_ec2_2_id
  port             = 3001
}

# --- Internal ALB Listener on port 3001 ---
resource "aws_lb_listener" "internal_alb_listener_jukpabi" {
  load_balancer_arn = aws_lb.internal_alb_jukpabi.arn
  port              = 3001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg_jukpabi.arn
  }
}
