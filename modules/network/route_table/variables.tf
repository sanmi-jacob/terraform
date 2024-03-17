variable "env" {}

variable "tags" {}

variable "cidr_route" {
    default = ""
}

variable "vpc_id" {}

variable "gw_id" {
    default = null
}

variable "nat_gw_id" {
    default = [null]
}

variable "type" {}

variable "cidrs" {}

variable "subnet_id" {}

variable "add_route" {
  default = false
}

