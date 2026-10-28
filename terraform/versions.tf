terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Partial config: bucket, key and region come from envs/<env>.backend.hcl.
  # S3 native locking (use_lockfile) replaces the DynamoDB lock table.
  backend "s3" {}
}
