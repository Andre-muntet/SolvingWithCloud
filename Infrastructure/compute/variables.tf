// alb

variable "alb_name" {
  type = string
}

variable "alb_target_group_name" {
  type = string
}

variable "http_port" {
  type = number
}

variable "http_protocol" {
  type = string
}

variable "alb_health_check_path" {
  type = string
}




//asg
variable "backend_ami" {
  type    = string
}

variable "backend_instance_type" {
  type    = string
}

variable "backend_root_volume_size" {
  type    = number
}

variable "backend_root_volume_type" {
  type    = string
}

variable "frontend_asg_min_size" {
  type    = number
}

variable "frontend_asg_desired_capacity" {
  type    = number
}

variable "frontend_asg_max_size" {
  type    = number
}

variable "common_tags" {
  type = map(string)
}

//inputs
variable "alb_security_group_id" {
  type = string
}

variable "frontend_security_group_id" {
  type = string
}

variable "backend_security_group_id" {
  type = string
}


variable "frontend_subnet_a_id" {
  type = string
}

variable "frontend_subnet_b_id" {
  type = string
}

variable "backend_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ec2_instance_profile_name" {
  type = string
}



variable "db_host" {
  type = string
}

variable "db_port" {
  type = number
}

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "backend_instance_profile_name" {
  type = string
}