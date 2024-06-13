variable "domain_name" {
  description = "The domain name to delegate in Cloudflare"
  type        = string
}

variable "aws_route53_name_servers" {
  description = "Route53 name servers"
  type        = list(string)
}

variable "cloudflare_email" {
  description = "Cloudflare account email"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
}

variable "account_id" {
  description = "Cloudflare API token"
  type        = string
}
