include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  root_locals = include.root.locals
}
