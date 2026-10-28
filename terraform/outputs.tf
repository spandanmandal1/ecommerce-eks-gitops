output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA roles"
  value       = module.eks.oidc_provider_arn
}

output "kubeconfig_command" {
  description = "Command to point kubectl at the cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}
