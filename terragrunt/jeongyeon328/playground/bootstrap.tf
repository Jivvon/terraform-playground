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

## outputs

output "public_ip" {
  value = try(module.bootstrap.instance.public_ip, null)
}
