variable "cluster_name" {
  type = string
}

variable "configure" {
  type = object({
    name    = string
    version = string
  })
}

variable "resolve_conflicts" {
  type    = string
  default = "OVERWRITE"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
