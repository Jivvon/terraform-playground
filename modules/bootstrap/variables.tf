variable "root_locals" {
  type = any
}

variable "git_repo_root" {
  type = string
}

variable "create_instance" {
  type    = bool
  default = false
}

variable "has_controlplane" {
  type    = bool
  default = false
}
