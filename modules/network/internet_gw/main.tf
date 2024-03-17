# Create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = merge({"Name" = "${var.env}_igw"
  },
  var.tags)

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}
