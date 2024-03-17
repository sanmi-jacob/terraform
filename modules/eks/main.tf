resource "aws_eks_cluster" "demo-eks" {
  name     = "${var.env}_cluster"
  role_arn = aws_iam_role.cluster_role.arn
  tags = merge({"Name" = "${var.env}_cluster",
  },
  var.tags)
  enabled_cluster_log_types = var.log_types
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
    ]
  }
  vpc_config { 
    security_group_ids = [var.security_group_id]
    subnet_ids     = var.subnet_id
    endpoint_private_access = true
    endpoint_public_access = true
    public_access_cidrs = ["0.0.0.0/0"]
  }
  
}

resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name              = "/aws/eks/${var.env}_cluster/cluster"
  retention_in_days = 7
  tags = merge({"Name" = "${var.env}_cluster"
  },
  var.tags)
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags
     
    ]
  }
}