locals {
  default_tags = {
    Environment = "devops"
    Terraform   = "true"
    createUser  = "lento"
    source      = "https://github.com/Jivvon/terraform-playground.git"
  }
}

terraform {
  required_version = ">= 1.5.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.7.0"
    }
  }
}

# default APN1
provider "aws" {
  region  = var.aws_config.aws_region
  profile = var.aws_config.aws_profile

  default_tags {
    tags = local.default_tags
  }
}
