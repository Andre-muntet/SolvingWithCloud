

variable "db_instance_class" {
  type    = string
}
variable "db_allocated_storage" {
  type    = number
}

variable "db_storage_type" {
  type    = string
}

variable "db_name" {
  type    = string
}

variable "db_username" {
  type    = string
}


variable "db_publicly_accessible" {
  type    = bool

}

variable "db_multi_az" {
  type    = bool

}

variable "db_skip_final_snapshot" {
  type    = bool
 
}

variable "common_tags" {
  type = map(string)
}


//inputs
variable "db_security_group_id" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}