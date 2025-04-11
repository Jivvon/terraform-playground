## modules

module "bootstrap" {
  source = "${var.git_repo_root}/modules/bootstrap"

  root_locals   = var.root_locals
  git_repo_root = var.git_repo_root
}

## variables

variable "root_locals" {
  type = any
}

variable "git_repo_root" {
  type = string
}

moved {
  from = module.instance
  to   = module.bootstrap.module.instance
}

moved {
  from = module.vcn
  to   = module.bootstrap.module.vcn
}

moved {
  from = oci_network_load_balancer_network_load_balancer.test_network_load_balancer
  to   = module.bootstrap.oci_network_load_balancer_network_load_balancer.test_network_load_balancer
}


