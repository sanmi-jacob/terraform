resource "aws_eks_node_group" "demo_node_group" {
  cluster_name = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn = var.node_iam_role
  subnet_ids = var.subnet_id
  instance_types = var.instance_type
  disk_size       = var.instance_disk_size
  capacity_type = var.capacity_type
  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = var.security_group_id
  }


  update_config {
    max_unavailable_percentage = var.max_unavailable_percentage
  }

  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
  tags = merge({"Name" = var.node_group_name,
  },
  var.tags)

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, scaling_config desired size
      tags["created_by"],
      tags["created_by_arn"],
      scaling_config.0.desired_size,
      scaling_config.0.min_size
    ]
  }
}

