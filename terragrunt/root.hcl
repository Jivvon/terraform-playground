locals {
  tfvars         = jsondecode(read_tfvars_file("${get_path_to_repo_root()}/terraform.tfvars.json"))
  account_locals = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals
  env_locals     = read_terragrunt_config("env.hcl").locals

  provider_configs = lookup(local.tfvars.backend, local.account_locals.tenancy, null)
  shared_configs   = lookup(local.tfvars, "shared", null)
}

generate backend {
  path      = "_backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "oci" {
  tenancy_ocid     = "${local.provider_configs.tenancy_ocid}"
  user_ocid        = "${local.provider_configs.user_ocid}"
  fingerprint      = "${local.provider_configs.fingerprint}"
  private_key_path = "${local.provider_configs.private_key_path}"
  region           = "${local.provider_configs.region}"
}
EOF
}

generate provider {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}
EOF
}