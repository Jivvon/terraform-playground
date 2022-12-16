locals {
  default_tags = {
    Environment = "devops" # devops, exp, production
    Terraform   = "true"
    createUser  = "lento"
  }
}

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

# default APN2
provider "aws" {
  region  = "ap-northeast-2"
  profile = "devops"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "APN1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "APN2"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "APN3"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "USE1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "USE2"

  default_tags {
    tags = local.default_tags
  }
}

# N. California
provider "aws" {
  region = "us-west-1"
  alias  = "USW1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "USW2"

  default_tags {
    tags = local.default_tags
  }
}
