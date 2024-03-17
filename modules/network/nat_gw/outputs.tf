output "ngw_id" {
  value = aws_nat_gateway.ngw.*.id
}

output "ngw_eip" {
  value = aws_nat_gateway.ngw.*.public_ip
}