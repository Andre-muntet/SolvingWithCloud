output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "frontend_security_group_id" {
  value = aws_security_group.ec2.id
}

output "backend_security_group_id" {
  value = aws_security_group.backend.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}

