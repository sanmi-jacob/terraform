resource "aws_route_table" "gw_route" {
  vpc_id = var.vpc_id
  tags = merge({"Name" = "${var.env}_${var.type}_route_table"
  },
  var.tags)

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}

resource "aws_route" "routes" {
  count = var.add_route ? 1 : 0
  route_table_id            = aws_route_table.gw_route.id
  destination_cidr_block    = var.cidr_route
  gateway_id                = var.gw_id
  nat_gateway_id            = var.nat_gw_id.0
  depends_on                = [aws_route_table.gw_route]
}

resource "aws_route_table_association" "route_association" {
  count          = length(var.cidrs)
  subnet_id      = var.subnet_id[count.index]
  route_table_id = aws_route_table.gw_route.id
  depends_on     = [aws_route_table.gw_route]

}


