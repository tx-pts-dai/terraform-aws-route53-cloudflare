variable "create" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = true
}

variable "cloudflare_delegation" {
  description = "Whether to delegate DNS to Cloudflare"
  type        = bool
  default     = false
}

variable "zones" {
  description = "A map of route53 zones to create"
  type = map(object({
    comment = optional(string, "")
  }))
  default = {}
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "cf_domain_name" {
  description = "The domain name to delegate in Cloudflare"
  type        = string
}

variable "cf_aws_route53_name_servers" {
  description = "Route53 name servers"
  type        = list(string)
}

variable "cf_account_id" {
  description = "Cloudflare API token"
  type        = string
}

variable "cf_cloudflare_delegation" {
  description = "Whether to delegate DNS to Cloudflare"
  type        = bool
  default     = false
}
