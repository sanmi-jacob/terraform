module "eks" {
  source                  	 = "./modules/eks"
  env               	 = var.purpose
  tags                    	 = merge(local.common_tags)
  subnet_id                  = module.private_subnet.subnet_ids
  security_group_id        	 = module.security_groups_eks.security_group_id
  log_types = []
}