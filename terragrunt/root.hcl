locals {
  backend_tfvars = jsondecode(read_tfvars_file("${get_path_to_repo_root()}/backend.tfvars.json"))
}

generate backend {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "oci" {
  tenancy_ocid     = "${local.backend_tfvars.oracle_jy.tenancy_ocid}"
  user_ocid        = "${local.backend_tfvars.oracle_jy.user_ocid}"
  fingerprint      = "${local.backend_tfvars.oracle_jy.fingerprint}"
  private_key_path = "${local.backend_tfvars.oracle_jy.private_key_path}"
  region           = "${local.backend_tfvars.oracle_jy.region}"
}
EOF
}

generate provider {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
    }
  }
}
EOF
}
