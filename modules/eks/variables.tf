variable "name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_role" {
  type = object({
    name = string
    arn  = string
  })
}

variable "node_group_role" {
  type = object({
    name = string
    arn  = string
  })
}

variable "service_accounts" {
  type = list(object({
    app_name              = string
    service_account_names = optional(list(string), [])
    namespace             = optional(string, "*")
    managed_policy_arns   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = object({
    Description = optional(string)
    Project     = optional(string)
    createUser  = optional(string)
  })
}

variable "logging" {
  type = list(string)

  # ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  default = []
}

variable "vpc" {
  type = object({
    id   = string
    cidr = string
  })
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_rules" {
  type = list(object({
    type        = optional(string, "ingress")
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "node_groups" {
  type = list(object({
    appset               = string
    product              = string
    instance_type        = string
    enable_default_taint = optional(bool, true)
    cluster_version      = optional(string)
    disk_size            = number
    desired_size         = number
    min_size             = number
    max_size             = number
  }))
  default = []
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = []
}
