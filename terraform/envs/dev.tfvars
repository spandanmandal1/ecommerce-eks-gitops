environment        = "dev"
region             = "ap-south-1"
availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
cluster_name       = "ecommerce-dev"

# Dev saves money: one NAT gateway and Spot nodes.
single_nat_gateway = true

node_groups = {
  general = {
    instance_types = ["t3.medium", "t3a.medium"]
    capacity_type  = "SPOT"
    scaling_config = {
      desired_size = 2
      max_size     = 4
      min_size     = 1
    }
  }
}
