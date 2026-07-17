terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
# Default provider
provider "aws" {
  region = var.aws_region

  # # Second provider
  # provider "aws" {
  #   alias  = "south"
  #   region = "ap-south-2"
  # }

  default_tags {
    tags = {
      Project   = "terraweek-2026"
      ManagedBy = "terraform"
      Day       = "03"
    }
  }
}
