output "endpoint" {
  value = aws_eks_cluster.demo-eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo-eks.certificate_authority[0].data
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = "${var.env}_cluster"
}

output "eks_cluster_id" {
  value = aws_eks_cluster.demo-eks.id
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = try(replace(aws_eks_cluster.demo-eks.identity[0].oidc[0].issuer, "https://", ""), "")
}