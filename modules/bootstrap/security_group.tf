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

resource "oci_core_network_security_group" "tailscale" {
  vcn_id         = module.vcn.vcn_id
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "tailscale"
}

resource "oci_core_network_security_group_security_rule" "tailscale_rule" {
  network_security_group_id = oci_core_network_security_group.tailscale.id
  direction                 = "INGRESS"
  protocol                  = "17" # UDP
  description               = "Allow Tailscale from anywhere"
  source_type               = "CIDR_BLOCK"
  source                    = "0.0.0.0/0"
  udp_options {
    destination_port_range {
      min = 41641
      max = 41641
    }
  }
}