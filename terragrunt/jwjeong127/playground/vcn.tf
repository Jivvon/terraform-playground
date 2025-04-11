locals {
  vpc_cidr_block = "10.0.0.0/16"
  # vpc cidr: /16
  # subnet cidr: /23, private: start from 0.0, public: start from 100.0
  # private_subnets = [
  #   cidrsubnet(local.vpc_cidr_block, 7, 0),
  #   cidrsubnet(local.vpc_cidr_block, 7, 1),
  #   cidrsubnet(local.vpc_cidr_block, 7, 2),
  #   cidrsubnet(local.vpc_cidr_block, 7, 3),
  # ]
  public_subnets = [
    cidrsubnet(local.vpc_cidr_block, 7, 50),
    cidrsubnet(local.vpc_cidr_block, 7, 51),
    cidrsubnet(local.vpc_cidr_block, 7, 52),
    cidrsubnet(local.vpc_cidr_block, 7, 53),
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
  vcn_cidrs                = [local.vpc_cidr_block]
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

resource "oci_core_network_security_group" "ssh" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "ssh"
}

resource "oci_core_network_security_group_security_rule" "ssh_rule" {
  network_security_group_id = oci_core_network_security_group.ssh.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  description               = "Allow SSH from anywhere"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group" "egress_all" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "egress-all"
}

resource "oci_core_network_security_group_security_rule" "egress_all" {
  network_security_group_id = oci_core_network_security_group.egress_all.id
  direction                 = "EGRESS"
  protocol                  = "all"
  description               = "Allow all Egress traffic"
  destination               = "0.0.0.0/0"
}
