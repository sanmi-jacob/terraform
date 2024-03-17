# Create vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge({"Name" = "${var.env}_VPC",
  },
  var.tags)

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}



