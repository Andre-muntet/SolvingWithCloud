resource "aws_lb" "frontend" {

  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_security_group_id]

  subnets = [
    var.frontend_subnet_a_id,
    var.frontend_subnet_b_id
  ]

  tags = var.common_tags
}

resource "aws_lb_target_group" "frontend" {

  name     = var.alb_target_group_name
  port     = var.http_port
  protocol = var.http_protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    protocol = var.http_protocol
    path     = var.alb_health_check_path
  }

  tags = var.common_tags
}

resource "aws_lb_listener" "frontend" {

  load_balancer_arn = aws_lb.frontend.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}