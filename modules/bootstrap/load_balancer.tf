resource "oci_network_load_balancer_network_load_balancer" "this" {
  count = var.create_instance ? 1 : 0

  compartment_id = var.root_locals.provider_configs.compartment_id
  display_name   = "network-loadbalancer"
  subnet_id      = module.vcn.subnet_id.public_0

  is_preserve_source_destination = false
  is_private                     = false

  network_security_group_ids = [
    oci_core_network_security_group.kubernetes.id,
    oci_core_network_security_group.egress_all.id,
    oci_core_network_security_group.ingress_https.id,
  ]
}

moved {
  from = oci_network_load_balancer_network_load_balancer.test_network_load_balancer
  to   = oci_network_load_balancer_network_load_balancer.this
}

resource "oci_network_load_balancer_backend_set" "this" {
  count = var.create_instance ? 1 : 0

  health_checker {
    protocol = "TCP"
    port     = 30361 # 30010
  }

  name                     = "kubernetes-nodes"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this[0].id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = false
}

resource "oci_network_load_balancer_backend" "kubernetes_nodeport" {
  count = var.create_instance ? (var.has_controlplane ? 1 : 2) : 0

  backend_set_name         = oci_network_load_balancer_backend_set.this[0].name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this[0].id
  port                     = 32549                                           # 30010
  target_id                = module.instance[0].instance_id[1 - count.index] # instance[0] could be controlplane
}

resource "oci_network_load_balancer_listener" "https" {
  count = var.create_instance ? 1 : 0

  default_backend_set_name = oci_network_load_balancer_backend_set.this[0].name
  name                     = "https"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this[0].id
  port                     = 443
  protocol                 = "TCP"
}

# resource "oci_network_load_balancer_listener" "kubernetes_nodeport" {
#   default_backend_set_name = oci_network_load_balancer_backend_set.this.name
#   name                     = "kubernetes-nodeport"
#   network_load_balancer_id = oci_network_load_balancer_network_load_balancer.this.id
#   port                     = 30010
#   protocol                 = "TCP"
# }
