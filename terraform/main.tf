provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "ecommerce-eks-gitops"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
  single_nat_gateway   = var.single_nat_gateway
}

module "eks" {
  source = "./modules/eks"

  cluster_name           = var.cluster_name
  cluster_version        = var.cluster_version
  subnet_ids             = module.vpc.private_subnet_ids
  node_groups            = var.node_groups
  endpoint_public_access = var.endpoint_public_access
  public_access_cidrs    = var.public_access_cidrs
}
