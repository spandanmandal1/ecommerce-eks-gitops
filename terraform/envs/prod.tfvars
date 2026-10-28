environment        = "prod"
region             = "ap-south-1"
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
cluster_name       = "ecommerce-prod"

private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
public_subnet_cidrs  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]

# Prod favours availability: a NAT gateway per AZ and on-demand nodes.
single_nat_gateway = false

node_groups = {
  general = {
    instance_types = ["t3.large"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 3
      max_size     = 6
      min_size     = 3
    }
  }
}
