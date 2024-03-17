# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet" {
  count             = length(var.cidrs)
  cidr_block        = var.cidrs[count.index]
  vpc_id            = var.vpc_id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge({"Name" = "${var.env_name}_${var.type}_subnet_${count.index + 1}"
  },
  var.tags)
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}


