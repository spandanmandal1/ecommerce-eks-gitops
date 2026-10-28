# Set bucket to the name you created with terraform/bootstrap.
bucket       = "CHANGE-ME-ecommerce-eks-tfstate"
key          = "prod/terraform.tfstate"
region       = "ap-south-1"
encrypt      = true
use_lockfile = true
