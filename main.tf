terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.49"
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
  count                    = var.cloudflare_delegation ? 1 : 0
  source                   = "./modules/cloudflare"
  account_id               = ""
  domain_name              = element([for k, v in var.zones : lookup(v, "domain_name", k)], 0) # assuming single domain
  aws_route53_name_servers = module.route_53_zone.route53_zone_name_servers
  providers = {
    cloudflare = cloudflare.cloudflare
  }
}

data "aws_secretsmanager_secret" "cloudflare_api_token" {
  name = "cloudflare/apitoken"
}

data "aws_secretsmanager_secret_version" "cloudflare_api_token" {
  secret_id = data.aws_secretsmanager_secret.cloudflare_api_token.id
}

provider "cloudflare" {
  alias     = "cloudflare"
  api_token = data.aws_secretsmanager_secret_version.cloudflare_api_token.secret_string
}
