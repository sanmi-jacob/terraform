module "vpc" {
  source   = "./modules/network/vpc"
  env      = "demo_vpc"
  vpc_cidr = var.vpc_cidr
  tags     = merge(local.common_tags)
}