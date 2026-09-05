// security

variable "backend_port" {
  type    = number
}

variable "db_port" {
  type    = number
}

// common

variable "common_tags" {
  type = map(string)

}

variable "http_port" {
  type    = number
}

variable "tcp_protocol" {
  type    = string
  
}

variable "http_protocol" {
  type    = string

}

variable "all_protocol" {
  type    = string
  
}

variable "internet_cidr" {
  type    = string

}

variable "all_ports_from" {
  type    = number
  
}

variable "all_ports_to" {
  type    = number

}

variable "vpc_id" {
  type = string
}