locals {
  common_tags = {
    purpose = "demo"
  }
  karpenter_tags = {
    "karpenter.sh/discovery" = "${var.purpose}-cluster"
  }
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "purpose" {
  default = "demo"
}
variable "private_subnet_type" {
  type = string
  default = "private"
}

variable "public_subnet_type" {
  type = string
  default = "public"
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "public_route" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ec2_ssh_key" {
  default = ""
}

data "aws_caller_identity" "current" {}

variable "oidc_arn" {
  default = "arn:aws:iam::372272712350:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/BDA6DB5F31D0776D2020A304EFA31F20"
}

variable "oidc_url" {
  default = "oidc.eks.eu-west-2.amazonaws.com/id/BDA6DB5F31D0776D2020A304EFA31F20"
}