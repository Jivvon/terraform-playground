locals {
  # vpc cidr: /16
  # subnet cidr: /23, private: start from 0.0, public: start from 100.0
  # private_subnets = [
  #   cidrsubnet(local.vpc_cidr_block, 7, 0),
  #   cidrsubnet(local.vpc_cidr_block, 7, 1),
  #   cidrsubnet(local.vpc_cidr_block, 7, 2),
  #   cidrsubnet(local.vpc_cidr_block, 7, 3),
  # ]
  public_subnets = [
    cidrsubnet(var.root_locals.env_locals.vpc_cidr_block, 7, 50),
    cidrsubnet(var.root_locals.env_locals.vpc_cidr_block, 7, 51),
    cidrsubnet(var.root_locals.env_locals.vpc_cidr_block, 7, 52),
    cidrsubnet(var.root_locals.env_locals.vpc_cidr_block, 7, 53),
  ]
}

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.6.0"

  region         = var.root_locals.provider_configs.region
  compartment_id = var.root_locals.provider_configs.compartment_id

  # vcn parameters
  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true

  nat_gateway_public_ip_id = "none"
  vcn_cidrs                = [var.root_locals.env_locals.vpc_cidr_block]
  vcn_name                 = var.root_locals.env_locals.stage

  subnets = merge({
    for idx, v in local.public_subnets : "public_${idx}" => {
      cidr_block = v
      type       = "public"
    }
  })

  # routing rules
  internet_gateway_route_rules = null
  nat_gateway_route_rules      = null
}
