# One-time setup: the S3 bucket that holds Terraform state for every environment.
# Run with local state, before the main stack:
#   terraform -chdir=terraform/bootstrap init
#   terraform -chdir=terraform/bootstrap apply -var bucket_name=<globally-unique-name>

terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Globally unique name for the state bucket"
  type        = string
}

resource "aws_s3_bucket" "terraform_state" {
  #checkov:skip=CKV_AWS_144:Cross-region replication is overkill for a demo state bucket
  #checkov:skip=CKV_AWS_145:SSE-S3 is enough here; KMS adds cost and key management
  #checkov:skip=CKV_AWS_18:Access logging needs a second bucket; versioning covers recovery
  #checkov:skip=CKV2_AWS_62:No consumer for event notifications
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_bucket_name" {
  description = "The name of the state bucket"
  value       = aws_s3_bucket.terraform_state.id
}

# Keep 90 days of old state versions for rollback, then expire them.
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "expire-old-state-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
