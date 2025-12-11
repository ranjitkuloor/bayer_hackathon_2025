terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }

  backend "s3" {
    bucket       = "bayer-hackathon-terraform-state-1"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = false
  }

}

provider "aws" {
  region = var.aws_region
}

# DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-locks"
  }
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "your-terraform-state-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "terraform-state"
  }
}

data "aws_caller_identity" "current" {}