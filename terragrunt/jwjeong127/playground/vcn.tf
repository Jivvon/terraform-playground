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
  vcn_cidrs                = ["10.0.0.0/16"]
  vcn_name                 = var.root_locals.env_locals.stage

  # routing rules
  internet_gateway_route_rules = null
  nat_gateway_route_rules      = null
}
