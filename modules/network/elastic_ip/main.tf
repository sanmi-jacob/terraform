resource "aws_eip" "elastic_ip" {
  count = length(var.azs)
  vpc = true
  tags = merge({"Name" = var.name != null ? var.name : "${var.env_name}_eip_${count.index+1}"
  },
  var.tags)

  instance = var.instance_id
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
      tags["created_by"], tags["created_by_arn"],
    ]
  }
}

