# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = var.aws_region_acceptor_id
  vpc_id        = data.aws_vpc.requestor_vpc.id
  peer_vpc_id   = var.acceptor_vpc_id
  provider      = aws.requestor
  auto_accept   = false
  


  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],tags["Side"],
    ]
  }
  tags = merge({"Side" = "Requestor",
  },
  var.tags)
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.acceptor
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
 
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],tags["Side"],
    ]
  }
  tags = merge({"Side" = "Accepter",
  },
  var.tags)
}

#Module      : ROUTE REQUESTOR
#Description : Create routes from requestor to acceptor.
resource "aws_route" "requestor_vpc_peering" {
  provider = aws.requestor
  count = length(data.aws_route_tables.requestor.ids)
  route_table_id = tolist(data.aws_route_tables.requestor.ids)[count.index]
  destination_cidr_block = data.aws_vpc.acceptor.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

#Module      : ROUTE ACCEPTOR
#Description : Create routes from acceptor to requestor.
resource "aws_route" "acceptor_vpc_peering" {
  provider = aws.acceptor
  count = length(data.aws_route_tables.acceptor.ids)
  route_table_id = tolist(data.aws_route_tables.acceptor.ids)[count.index]
  destination_cidr_block = data.aws_vpc.requestor_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
