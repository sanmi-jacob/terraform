locals{
  ingress_rules = var.sg_ingress_rules
  egress_rules = var.sg_egress_rules
  ingress_rules_source_sg = var.ingress_rules_source_sg
  egress_rules_source_sg = var.egress_rules_source_sg
  self_sg_ingress_rules = var.self_sg_ingress_rules
  self_sg_egress_rules = var.self_sg_egress_rules
  ingress_rules_pl_ids = var.ingress_rules_pl_ids
  egress_rules_pl_ids = var.egress_rules_pl_ids
  }



resource "aws_security_group" "demo-sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge({"Name" = var.name
    },
    var.tags)

  lifecycle {
    ignore_changes = [
    
  
    ]
  }
}

resource "aws_security_group_rule" "demo-ingress" {
  count = length(local.ingress_rules)
  type = "ingress"
  from_port   = local.ingress_rules[count.index].from_port
  to_port     = local.ingress_rules[count.index].to_port
  protocol    = local.ingress_rules[count.index].protocol
  cidr_blocks = [local.ingress_rules[count.index].cidr_block]
  description = local.ingress_rules[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-egress" {
  count = length(local.egress_rules)
  type = "egress"
  from_port   = local.egress_rules[count.index].from_port
  to_port     = local.egress_rules[count.index].to_port
  protocol    = local.egress_rules[count.index].protocol
  cidr_blocks = [local.egress_rules[count.index].cidr_block]
  description = local.egress_rules[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-ingress-source-sg" {
  count = length(local.ingress_rules_source_sg)
  type = "ingress"
  from_port   = local.ingress_rules_source_sg[count.index].from_port
  to_port     = local.ingress_rules_source_sg[count.index].to_port
  protocol    = local.ingress_rules_source_sg[count.index].protocol
  source_security_group_id = local.ingress_rules_source_sg[count.index].source_security_group_id
  description = local.ingress_rules_source_sg[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-egress-source-sg" {
  count = length(local.egress_rules_source_sg)
  type = "egress"
  from_port   = local.egress_rules_source_sg[count.index].from_port
  to_port     = local.egress_rules_source_sg[count.index].to_port
  protocol    = local.egress_rules_source_sg[count.index].protocol
  source_security_group_id = local.egress_rules_source_sg[count.index].source_security_group_id
  description = local.egress_rules_source_sg[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-ingress-self-sg" {
  count = length(local.self_sg_ingress_rules)
  type = "ingress"
  from_port   = local.self_sg_ingress_rules[count.index].from_port
  to_port     = local.self_sg_ingress_rules[count.index].to_port
  protocol    = local.self_sg_ingress_rules[count.index].protocol
  self = local.self_sg_ingress_rules[count.index].self
  description = local.self_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-egress-self-sg" {
  count = length(local.self_sg_egress_rules)
  type = "egress"
  from_port   = local.self_sg_egress_rules[count.index].from_port
  to_port     = local.self_sg_egress_rules[count.index].to_port
  protocol    = local.self_sg_egress_rules[count.index].protocol
  self = local.self_sg_egress_rules[count.index].self
  description = local.self_sg_egress_rules[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-ingress-prefix-list" {
  count = length(local.ingress_rules_pl_ids)
  type = "ingress"
  from_port   = local.ingress_rules_pl_ids[count.index].from_port
  to_port     = local.ingress_rules_pl_ids[count.index].to_port
  protocol    = local.ingress_rules_pl_ids[count.index].protocol
  prefix_list_ids = [local.ingress_rules_pl_ids[count.index].prefix_list_ids]
  description = local.ingress_rules_pl_ids[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}

resource "aws_security_group_rule" "demo-egress-prefix-list" {
  count = length(local.egress_rules_pl_ids)
  type = "egress"
  from_port   = local.egress_rules_pl_ids[count.index].from_port
  to_port     = local.egress_rules_pl_ids[count.index].to_port
  protocol    = local.egress_rules_pl_ids[count.index].protocol
  prefix_list_ids = [local.egress_rules_pl_ids[count.index].prefix_list_ids]
  description = local.egress_rules_pl_ids[count.index].description
  security_group_id = aws_security_group.demo-sg.id
}


output "security_group_id" {
  value = aws_security_group.demo-sg.id
}
