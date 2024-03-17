locals {
nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : 0
}

resource "aws_nat_gateway" "ngw" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(var.elastic_ip_id , count.index )
  subnet_id = element( var.subnet_id, var.single_nat_gateway ? 0 : count.index )
  tags = merge({"Name" =  "${var.env_name}_nat_gw_${count.index+1}"
  },
  var.tags)
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}

