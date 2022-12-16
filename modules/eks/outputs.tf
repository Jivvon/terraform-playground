output "oidc_provider_arn" {
  value = module.iam.oidc_provider_arn
}

output "oidc_provider_issuer_url" {
  value = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

output "additional_security_group_id" {
  value = aws_security_group.this.id
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
