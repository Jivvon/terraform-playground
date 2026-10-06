terraform {
  required_version = ">= 1.9.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

# Uses CLOUDFLARE_API_TOKEN from the execution environment. Never put tokens in tfvars.
provider "cloudflare" {}

variable "zone_id" {
  description = "Cloudflare zone ID for jwjeong127.com."
  type        = string
  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.zone_id))
    error_message = "Provide the existing jwjeong127.com zone ID."
  }
}

variable "tailscale_ingress_ip" {
  description = "Existing admin.jwjeong127.com Tailscale ingress IPv4; verify before applying."
  type        = string
  default     = "100.122.136.74"
  validation {
    condition = can(cidrnetmask("${var.tailscale_ingress_ip}/32")) && can(regex(
      "^100\\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\\.", var.tailscale_ingress_ip
    ))
    error_message = "The private ingress must be an IPv4 address in Tailscale's 100.64.0.0/10 range."
  }
}

resource "cloudflare_dns_record" "blog_dev" {
  zone_id = var.zone_id
  name    = "blog.dev.jwjeong127.com"
  type    = "A"
  content = var.tailscale_ingress_ip
  ttl     = 300
  proxied = false
  comment = "Private blog and personal archive; access through Tailscale only."

  lifecycle {
    prevent_destroy = true
  }
}

output "hostname" {
  value = cloudflare_dns_record.blog_dev.name
}
