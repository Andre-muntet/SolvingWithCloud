output "frontend_subnet_a_id" {
  value = aws_subnet.frontend_a.id
}

output "frontend_subnet_b_id" {
  value = aws_subnet.frontend_b.id
}

output "backend_subnet_id" {
  value = aws_subnet.backend_a.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.database.name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}