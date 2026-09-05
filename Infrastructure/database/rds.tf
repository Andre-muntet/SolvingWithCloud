resource "aws_db_instance" "postgres" {

  identifier = "three-tier-postgres"

  engine         = "postgres"
  engine_version = "17"

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type

  db_name  = var.db_name
  
  username                    = var.db_username
  manage_master_user_password = true


  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.db_security_group_id]
  
  publicly_accessible = var.db_publicly_accessible
  multi_az            = var.db_multi_az

  skip_final_snapshot = var.db_skip_final_snapshot

  tags = var.common_tags
}