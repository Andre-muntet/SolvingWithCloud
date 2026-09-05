
resource "aws_launch_template" "frontend" {

  name = "lt-three-tier-frontend"

  image_id      = var.backend_ami
  instance_type = var.backend_instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.frontend_security_group_id]
  }
  iam_instance_profile {
    name = var.frontend_instance_profile_name
  }

  user_data = <<-EOF
  #!/bin/bash

  dnf install -y nginx

  aws s3 cp s3://three-tier-artifacts/frontend/ /usr/share/nginx/html/ --recursive

  systemctl enable nginx
  systemctl start nginx
EOF
  


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.backend_root_volume_size
      volume_type = var.backend_root_volume_type
    }
  }

}