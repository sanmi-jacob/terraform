output "eip_id" {
    value = aws_eip.elastic_ip.*.id
}