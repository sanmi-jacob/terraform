module "vpc" {
  source   = "./modules/network/vpc"
  env      = "demo"
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

module "private_route_table_and_association" {
  source     = "./modules/network/route_table"
  env   = "${var.purpose}_${var.environment}"
  type       = var.private_subnet_type
  tags       = merge(local.common_tags)
  vpc_id     = module.vpc.vpc_id
  cidr_route = var.public_route
  nat_gw_id  = module.nat_gw.ngw_id
  cidrs      = var.private_subnet_cidrs
  subnet_id  = module.private_subnet.subnet_ids
  add_route  = true
}

module "public_route_table_and_association" {
  source     = "./modules/network/route_table"
  env   = "${var.purpose}_${var.environment}"
  type       = var.public_subnet_type
  tags       = merge(local.common_tags)
  vpc_id     = module.vpc.vpc_id
  cidr_route = var.public_route
  gw_id      = module.igw.igw_id
  cidrs      = var.public_subnet_cidrs
  subnet_id  = module.public_subnet.subnet_ids
  add_route  = true
}

//NACL
locals {
  private_nacl_ingress_rules = [
    { rule_no = 100, from_port = 0, to_port = 65535, protocol = "-1", cidr_block = "0.0.0.0/0", action = "allow"},
  ]

  private_nacl_egress_rules = [
    { rule_no = 100, from_port = 0, to_port = 65535, protocol = "-1", cidr_block = "0.0.0.0/0", action = "allow"},
  ]

}
module "private_nacl" {
  source = "./modules/network/nacl"
  name   = "${var.purpose}_private_nacl"
  vpc_id   = module.vpc.vpc_id
  tags     = merge(local.common_tags)
  subnet_id  = module.private_subnet.subnet_ids
  nacl_ingress_rules = local.private_nacl_ingress_rules
  nacl_egress_rules  = local.private_nacl_egress_rules
}
locals {
  public_nacl_ingress_rules = [
    { rule_no = 100, from_port = 0, to_port = 65535, protocol = "-1", cidr_block = "0.0.0.0/0", action = "allow"},
  ]
  public_nacl_egress_rules = [
    { rule_no = 100, from_port = 0, to_port = 65535, protocol = "-1", cidr_block = "0.0.0.0/0", action = "allow"},
  ]
}
module "public_nacl" {
  source = "./modules/network/nacl"
  name   = "${var.purpose}_public_nacl"
  vpc_id   = module.vpc.vpc_id
  subnet_id     = module.public_subnet.subnet_ids
  tags     = merge(local.common_tags)
  nacl_ingress_rules = local.public_nacl_ingress_rules
  nacl_egress_rules  = local.public_nacl_egress_rules
}

//gateways
module "igw" {
  source   = "./modules/network/internet_gw"
  env = "${var.purpose}"
  tags     = merge(local.common_tags)
  vpc_id   = module.vpc.vpc_id
}

module "nat_gw" {
  source        = "./modules/network/nat_gw"
  env_name      = "${var.purpose}"
  tags          = merge(local.common_tags)
  elastic_ip_id = module.elasticip.eip_id
  cidrs         = var.public_subnet_cidrs
  subnet_id     = module.public_subnet.subnet_ids
  depends_on    = [module.igw]
}
//EIP
module "elasticip" {
  source   = "./modules/network/elastic_ip"
  env_name = "${var.purpose}"
  tags     = merge(local.common_tags)
}