terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.49"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 2.20"
    }
  }
}

module "route_53_zone" {
  source = "./modules/route53"
  zones  = var.zones
  create = var.create
  tags   = var.tags
}

module "cloudflare_delegation" {
  source                   = "./modules/cloudflare"
  account_id               = ""
  domain_name              = element([for k, v in var.zones : lookup(v, "domain_name", k)], 0) # assuming single domain
  aws_route53_name_servers = module.route_53_zone.route53_zone_name_servers
  providers = {
    cloudflare = cloudflare
  }
  cloudflare_delegation = var.cloudflare_delegation 
}

