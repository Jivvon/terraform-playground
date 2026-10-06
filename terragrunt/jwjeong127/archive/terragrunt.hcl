include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/modules/archive"
}

inputs = {
  compartment_id = include.root.locals.provider_configs.compartment_id
}
