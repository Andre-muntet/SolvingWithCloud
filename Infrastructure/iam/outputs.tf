output "frontend_instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}

output "backend_instance_profile_name" {
  value = aws_iam_instance_profile.backend.name
}