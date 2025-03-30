resource "oci_network_load_balancer_network_load_balancer" "test_network_load_balancer" {
  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "network-loadbalancer"
  subnet_id      = module.vcn.subnet_id.public_0

  is_preserve_source_destination = false
  is_private                     = false
}
