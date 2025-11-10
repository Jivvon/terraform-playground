include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  root_locals   = include.root.locals
  git_repo_root = get_repo_root()
}
