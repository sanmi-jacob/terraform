variable "name" {}

variable "tags" {}

variable "vpc_id" {}

variable "description" {}

# variable "vpn_cidrs" {
#     default = "10.0.8.0/24"
# }

variable "public_anywhere" {
    default = "0.0.0.0/0"
}

variable "sg_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      description = string
    }))
    default = []
}

variable "sg_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      description = string
    }))
    default = []
}

variable "ingress_rules_source_sg" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id  = string
      description = string
    }))
    default = []
}

variable "egress_rules_source_sg" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id  = string
      description = string
    }))
    default = []
}

variable "ingress_rules_pl_ids" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      prefix_list_ids  = string
      description = string
    }))
    default = []
}

variable "egress_rules_pl_ids" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      prefix_list_ids  = string
      description = string
    }))
    default = []
}

variable "self_sg_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      self  = bool
      description = string
    }))
    default = []
}

variable "self_sg_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      self  = bool
      description = string
    }))
    default = []
}