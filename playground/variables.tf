variable "aws_config" {
  type = object({
    aws_region  = string
    aws_profile = string
  })
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_rules" {
  type = object({
    ingress = optional(list(string), [])
    egress  = optional(list(string), [])
  })
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "key_name" {
  type = string
}
