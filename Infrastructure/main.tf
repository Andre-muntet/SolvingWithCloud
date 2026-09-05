module "network" {
  source = "./network"

  vpc_cidr_block  = var.vpc_cidr_block
  frontend_a_cidr = var.frontend_a_cidr
  frontend_b_cidr = var.frontend_b_cidr
  backend_a_cidr  = var.backend_a_cidr
  db_a_cidr       = var.db_a_cidr
  db_b_cidr       = var.db_b_cidr
  internet_cidr   = var.internet_cidr
  all_ports_from  = var.all_ports_from
  all_ports_to    = var.all_ports_to
  http_port       = var.http_port
  tcp_protocol    = var.tcp_protocol
  all_protocol    = var.all_protocol
  http_protocol   = var.http_protocol
  common_tags     = var.common_tags

}
module "security" {
  source         = "./security"
  backend_port   = var.backend_port
  db_port        = var.db_port
  http_port      = var.http_port
  tcp_protocol   = var.tcp_protocol
  http_protocol  = var.http_protocol
  all_protocol   = var.all_protocol
  internet_cidr  = var.internet_cidr
  all_ports_from = var.all_ports_from
  all_ports_to   = var.all_ports_to
  common_tags    = var.common_tags

  vpc_id = module.network.vpc_id
}

module "compute" {
  source = "./compute"

  alb_name                      = var.alb_name
  alb_target_group_name         = var.alb_target_group_name
  alb_health_check_path         = var.alb_health_check_path
  http_port                     = var.http_port
  http_protocol                 = var.http_protocol
  frontend_asg_min_size         = var.frontend_asg_min_size
  frontend_asg_desired_capacity = var.frontend_asg_desired_capacity
  frontend_asg_max_size         = var.frontend_asg_max_size
  backend_ami                   = var.backend_ami
  backend_instance_type         = var.backend_instance_type
  backend_root_volume_size      = var.backend_root_volume_size
  backend_root_volume_type      = var.backend_root_volume_type
  common_tags                   = var.common_tags

  alb_security_group_id          = module.security.alb_security_group_id
  frontend_security_group_id     = module.security.frontend_security_group_id
  backend_security_group_id      = module.security.backend_security_group_id
  vpc_id                         = module.network.vpc_id
  frontend_subnet_a_id           = module.network.frontend_subnet_a_id
  frontend_subnet_b_id           = module.network.frontend_subnet_b_id
  backend_subnet_id              = module.network.backend_subnet_id
  frontend_instance_profile_name = module.iam.frontend_instance_profile_name
  db_host                        = module.database.rds_endpoint
  db_port                        = module.database.rds_port
  db_username                    = module.database.rds_username
  db_name                        = module.database.rds_db_name
  backend_instance_profile_name  = module.iam.backend_instance_profile_name

}

module "database" {
  source                 = "./database"
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  db_storage_type        = var.db_storage_type
  db_name                = var.db_name
  db_username            = var.db_username
  db_publicly_accessible = var.db_publicly_accessible
  db_multi_az            = var.db_multi_az
  db_skip_final_snapshot = var.db_skip_final_snapshot
  common_tags            = var.common_tags
  db_security_group_id   = module.security.db_security_group_id
  db_subnet_group_name   = module.network.db_subnet_group_name


}

module "storage" {
  source = "./storage"

  common_tags = var.common_tags
}

module "iam" {
  source = "./iam"

  common_tags    = var.common_tags
  bucket_arn     = module.storage.bucket_arn
  rds_secret_arn = module.database.rds_secret_arn

}