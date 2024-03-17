output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "default_network_acl_id" {
  value = aws_vpc.vpc.default_network_acl_id
}

output "default_route_table_id" {
  value = aws_vpc.vpc.default_route_table_id
}