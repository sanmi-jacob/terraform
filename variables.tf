locals {
  common_tags = {
    purpose = "demo"
  }
#   karpenter_tags = {
#     "karpenter.sh/discovery" = "${var.purpose}_${var.environment}_${data.aws_region.current.name}_cluster"
#   }
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}