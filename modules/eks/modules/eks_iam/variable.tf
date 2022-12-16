variable "cluster_name" {
  type = string
}

variable "oidc_provider_issuer" {
  type = string
}

variable "service_accounts" {
  type = list(object({
    app_name              = string
    service_account_names = list(string)
    namespace             = string
    managed_policy_arns   = list(string)
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
