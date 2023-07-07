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
}

# default APN1
provider "aws" {
  region  = "ap-northeast-1"
  profile = "devops"

  default_tags {
    tags = local.default_tags
  }
}
