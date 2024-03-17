locals{
  ingress_rules = var.nacl_ingress_rules
  egress_rules = var.nacl_egress_rules
  }

resource "aws_network_acl" "demo-nacl" {
  vpc_id = var.vpc_id
  subnet_ids =  var.subnet_id
  tags = merge({"Name" = "${var.name}"
  })

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}

resource "aws_network_acl_rule" "demo-nacl-ingress" {
  network_acl_id = aws_network_acl.demo-nacl.id
  egress = false
  count = length(local.ingress_rules)
  protocol   = local.ingress_rules[count.index].protocol
  rule_number    = local.ingress_rules[count.index].rule_no
  rule_action     = local.ingress_rules[count.index].action
  cidr_block = local.ingress_rules[count.index].cidr_block
  from_port  = local.ingress_rules[count.index].from_port
  to_port    = local.ingress_rules[count.index].to_port
}

resource "aws_network_acl_rule" "demo-nacl-egress" {
  network_acl_id = aws_network_acl.demo-nacl.id
  egress = true
  count = length(local.egress_rules)
  protocol   = local.egress_rules[count.index].protocol
  rule_number    = local.egress_rules[count.index].rule_no
  rule_action     = local.egress_rules[count.index].action
  cidr_block = local.egress_rules[count.index].cidr_block
  from_port  = local.egress_rules[count.index].from_port
  to_port    = local.egress_rules[count.index].to_port
}
