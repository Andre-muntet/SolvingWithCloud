
resource "aws_autoscaling_group" "frontend" {

  min_size         = var.frontend_asg_min_size
  desired_capacity = var.frontend_asg_desired_capacity
  max_size         = var.frontend_asg_max_size

  vpc_zone_identifier = [
    var.frontend_subnet_a_id,
    var.frontend_subnet_b_id
  ]

  target_group_arns = [
    aws_lb_target_group.frontend.arn
  ]

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "three-tier-frontend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.common_tags["Project"]
    propagate_at_launch = true
  }
}

// BE ec2

resource "aws_instance" "backend" {

  ami           = var.backend_ami
  instance_type = var.backend_instance_type

  subnet_id = var.backend_subnet_id

  vpc_security_group_ids = [
    var.backend_security_group_id
  ]

  associate_public_ip_address = false

  iam_instance_profile = var.backend_instance_profile_name
  root_block_device {
    volume_size = var.backend_root_volume_size
    volume_type = var.backend_root_volume_type
  }

  tags = merge(var.common_tags, {
    Name = "three-tier-backend"
  })

user_data = <<-EOF
  #!/bin/bash

  # Database configuration

  export DB_HOST="${var.db_host}"
  export DB_PORT="${var.db_port}"
  export DB_USER="${var.db_username}"
  export DB_NAME="${var.db_name}"

  # Get database password from Secrets Manager
  SECRET=$(aws secretsmanager get-secret-value \
    --secret-id "${var.rds_secret_arn}" \
    --query SecretString \
    --output text)

  export DB_PASSWORD=$(python3 -c "import json,sys; print(json.loads(sys.argv[1])['password'])" "$SECRET")

  # Install Node.js
  curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
  dnf install -y nodejs

  # Create application directory
  mkdir -p /opt/backend

  # Wait for backend application to become available in S3
  until aws s3api head-object --bucket three-tier-artifacts --key backend/package.json >/dev/null 2>&1; do
    echo "Backend files not available in S3. Retrying in 30 seconds..."
    sleep 30
  done

  # Download backend application from S3
  aws s3 cp s3://three-tier-artifacts/backend/ /opt/backend/ --recursive

  # Move into application directory
  cd /opt/backend

  # Install dependencies
  npm ci

  # Build TypeScript
  npm run build

  # Start backend
  npm start
EOF

}