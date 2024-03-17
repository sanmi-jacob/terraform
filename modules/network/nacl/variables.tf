variable "name" {}

variable "tags" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "public_anywhere" {
    default = "0.0.0.0/0"
}

variable "nacl_ingress_rules" {
    type = list(object({
      rule_no     = number
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      action      = string
    }))
}

variable "nacl_egress_rules" {
    type = list(object({
      rule_no     = number
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      action      = string
    }))
}
