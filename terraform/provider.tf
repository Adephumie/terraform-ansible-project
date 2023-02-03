# Terraform AWS Provider block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Configure local provider
provider "local" {
  # Configuration options
}