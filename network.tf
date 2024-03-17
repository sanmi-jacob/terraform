module "vpc" {
  source   = "./modules/network/vpc"
  env      = "demo_vpc"
  vpc_cidr = var.vpc_cidr
  tags     = merge(local.common_tags)
}

module "public_subnet" {
  source   = "./modules/network/subnet"
  env_name = "${var.purpose}"
  type     = var.public_subnet_type
  tags     = merge(local.common_tags, {"Tier" = "Public"}, { "kubernetes.io/cluster/${var.purpose}-cluster" = "shared" }, {"kubernetes.io/role/elb" = 1})
  cidrs    = var.public_subnet_cidrs
  vpc_id   = module.vpc.vpc_id
}

module "private_subnet" {
  source   = "./modules/network/subnet"
  env_name = "${var.purpose}"
  type     = var.private_subnet_type
  tags     = merge(local.common_tags, {"Tier" = "Private"},{ "kubernetes.io/cluster/${var.purpose}-cluster" = "shared" }, { "kubernetes.io/role/internal-elb" = 1},local.karpenter_tags)
  cidrs    = var.private_subnet_cidrs
  vpc_id   = module.vpc.vpc_id
}