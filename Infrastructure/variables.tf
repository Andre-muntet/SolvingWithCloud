
// alb

variable "alb_name" {
  type    = string
  default = "three-tier-frontend-alb"
}

variable "alb_target_group_name" {
  type    = string
  default = "three-tier-frontend-tg"
}

variable "alb_health_check_path" {
  type    = string
  default = "/"
}


// asg

variable "frontend_asg_min_size" {
  type    = number
  default = 2
}

variable "frontend_asg_desired_capacity" {
  type    = number
  default = 2
}

variable "frontend_asg_max_size" {
  type    = number
  default = 4
}


// backend ec2

variable "backend_ami" {
  type    = string
  default = "ami-024188f9a1259d3f6"
}

variable "backend_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "backend_root_volume_size" {
  type    = number
  default = 8
}

variable "backend_root_volume_type" {
  type    = string
  default = "gp3"
}


// db

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_storage_type" {
  type    = string
  default = "gp3"
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "three_tier_user"
}


variable "db_publicly_accessible" {
  type    = bool
  default = false
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}


// subnet

variable "frontend_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "frontend_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "backend_a_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "db_a_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "db_b_cidr" {
  type    = string
  default = "10.0.5.0/24"
}


// vpc

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}


// security

variable "backend_port" {
  type    = number
  default = 8080
}

variable "db_port" {
  type    = number
  default = 5432
}


// common

variable "common_tags" {
  type = map(string)

  default = {
    Project = "three-tier-application"
  }
}

variable "http_port" {
  type    = number
  default = 80
}

variable "tcp_protocol" {
  type    = string
  default = "tcp"
}

variable "http_protocol" {
  type    = string
  default = "HTTP"
}

variable "all_protocol" {
  type    = string
  default = "-1"
}

variable "internet_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "all_ports_from" {
  type    = number
  default = 0
}

variable "all_ports_to" {
  type    = number
  default = 0
}




