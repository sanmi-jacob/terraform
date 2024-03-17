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
  tags     = merge(local.common_tags, {"Tier" = "Public"}, { "kubernetes.io/cluster/${var.purpose}_cluster" = "shared" }, {"kubernetes.io/role/elb" = 1})
  cidrs    = var.public_subnet_cidrs
  vpc_id   = module.vpc.vpc_id
}

module "private_subnet" {
  source   = "./modules/network/subnet"
  env_name = "${var.purpose}"
  type     = var.private_subnet_type
  tags     = merge(local.common_tags, {"Tier" = "Private"},{ "kubernetes.io/cluster/${var.purpose}_cluster" = "shared" }, { "kubernetes.io/role/internal-elb" = 1},local.karpenter_tags)
  cidrs    = var.private_subnet_cidrs
  vpc_id   = module.vpc.vpc_id
}

module "private_route_table_and_association" {
  source     = "./modules/network/route_table"
  env   = "${var.purpose}"
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
  env   = "${var.purpose}"
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

//security group

locals {
// EKS Inbound/Outbound SecurityGroup Rules
  eks_ingress_rules_sg = [
    { from_port = 443, to_port = 443, protocol = "tcp", source_security_group_id = module.security_groups_eks_node.security_group_id, description = "Request coming from nodes" },
  ]
  eks_sg_ingress_rules = [
    {from_port = 443,to_port = 443, protocol = "tcp",cidr_block = "0.0.0.0/0",description = "public access"} //shared vpc cider 
  ]
  eks_egress_rules_sg = [{ from_port = 0, to_port = 65535, protocol = "tcp", source_security_group_id = module.security_groups_eks_node.security_group_id, description = "For kubelet API" }]


// NODE Inbound/Outbound SecurityGroup Rules
  eks_node_ingress_rules_sg = [
    { from_port = 10250, to_port = 10250, protocol = "tcp", source_security_group_id = module.security_groups_eks.security_group_id, description = "For kubelet API" },
  ]
  eks_node_egress_rules_sg = [
  { from_port = 443, to_port = 443, protocol = "tcp", source_security_group_id = module.security_groups_eks.security_group_id, description = "For Cluster Communication" }
]
  self_eks_node_ingress_rules_sg = [
    {from_port = 0, to_port = 65535, protocol = "all", self = true, description = "For inter-node communication"}
  ]
  self_eks_node_egress_rules_sg = [
    {from_port = 0, to_port = 65535, protocol = "all", self = true, description = "For inter-node communication"}
  ]
}



//EKS SecurityGroup
module "security_groups_eks" {
  source   = "./modules/security_group"
  name = "${var.purpose}_eks_sg"
  description = "Cluster communication with worker nodes"
  tags     = merge(local.common_tags)
  vpc_id   = module.vpc.vpc_id
  sg_ingress_rules = local.eks_sg_ingress_rules
  ingress_rules_source_sg = local.eks_ingress_rules_sg
  egress_rules_source_sg =  local.eks_egress_rules_sg
}

//Node SecurityGroup
module "security_groups_eks_node" {
  source   = "./modules/security_group"
  name = "${var.purpose}_eks_node_sg"
  description = "Node communication with EKS Cluster"
  tags     = merge(local.common_tags, { "kubernetes.io/cluster/${var.purpose}_cluster" = "owned" },local.karpenter_tags)
  vpc_id   = module.vpc.vpc_id
  ingress_rules_source_sg = local.eks_node_ingress_rules_sg
  egress_rules_source_sg =  local.eks_node_egress_rules_sg
  self_sg_ingress_rules = local.self_eks_node_ingress_rules_sg
  self_sg_egress_rules =  local.self_eks_node_egress_rules_sg
}

locals {
    ec2_default_app_ingress_rules_sg = []
    ec2_default_app_egress_rules_sg = []
    ec2_default_app_sg_egress_rules = [
    ]
    ec2_default_app_egress_rules_pl_ids = []

}

//app security group
module "ec2_default_app_security_groups" {
  source = "./modules/security_group"
  name = "${var.purpose}_ec2_default_app_sg"
  description = "Default App SG for ec2 instances"
  tags = merge(local.common_tags)
  vpc_id = module.vpc.vpc_id
  sg_egress_rules = local.ec2_default_app_sg_egress_rules
  ingress_rules_source_sg = local.ec2_default_app_ingress_rules_sg
  egress_rules_source_sg = local.ec2_default_app_egress_rules_sg
 
} 
