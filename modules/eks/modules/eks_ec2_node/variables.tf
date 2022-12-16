variable "appset" {
  type = string
}

variable "product" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "node_group_role" {
  type = object({
    name = string
    arn  = string
  })
}

variable "subnet_ids" {
  type = list(string)
}

variable "disk_size" {
  type    = number
  default = 50
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "enable_default_taint" {
  type = bool
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
