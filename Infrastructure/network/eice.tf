resource "aws_ec2_instance_connect_endpoint" "backend" {
  subnet_id          = aws_subnet.backend_a.id
  security_group_ids = [var.eice_security_group_id]

  tags = merge(var.common_tags, {
    Name = "three-tier-eice"
  })
}