resource "aws_security_group" "alb" {

  name        = "three-tier-alb-sg"
  description = "Security group for the frontend Application Load Balancer"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_protocol
    cidr_blocks = [var.internet_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = var.all_ports_from
    to_port     = var.all_ports_to
    protocol    = var.all_protocol
    cidr_blocks = [var.internet_cidr]
  }

  tags = var.common_tags
}

resource "aws_security_group" "ec2" {

  name        = "three-tier-frontend-sg"
  description = "Security group for frontend EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP traffic from the ALB"
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = var.all_ports_from
    to_port     = var.all_ports_to
    protocol    = var.all_protocol
    cidr_blocks = [var.internet_cidr]
  }

  tags = var.common_tags
}

resource "aws_security_group" "backend" {

  name        = "three-tier-backend-sg"
  description = "Security group for backend EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow backend traffic from the frontend"
    from_port       = var.backend_port
    to_port         = var.backend_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = var.all_ports_from
    to_port     = var.all_ports_to
    protocol    = var.all_protocol
    cidr_blocks = [var.internet_cidr]
  }

  tags = var.common_tags
}

resource "aws_security_group" "db" {

  name        = "three-tier-db-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL traffic from backend"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = var.tcp_protocol
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = var.all_ports_from
    to_port     = var.all_ports_to
    protocol    = var.all_protocol
    cidr_blocks = [var.internet_cidr]
  }

  tags = var.common_tags
}