
variable "frontend_a_cidr" {
  type = string
}

variable "frontend_b_cidr" {
  type = string
}

variable "backend_a_cidr" {
  type = string
}

variable "db_a_cidr" {
  type = string
}

variable "db_b_cidr" {
  type = string
}


// vpc

variable "vpc_cidr_block" {
  type = string
}




// common

variable "common_tags" {
  type = map(string)

}

variable "http_port" {
  type = number
}

variable "tcp_protocol" {
  type = string

}

variable "http_protocol" {
  type = string

}

variable "all_protocol" {
  type = string

}

variable "internet_cidr" {
  type = string

}

variable "all_ports_from" {
  type = number

}

variable "all_ports_to" {
  type = number

}
variable "eice_security_group_id" {
  type = string
}