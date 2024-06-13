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

data "aws_secretsmanager_secret" "cloudflare_api_token" {
  name = "cloudflare/apitoken"
}

data "aws_secretsmanager_secret_version" "cloudflare_api_token" {
  secret_id = data.aws_secretsmanager_secret.cloudflare_api_token.id
}

provider "cloudflare" {
  api_token = data.aws_secretsmanager_secret_version.cloudflare_api_token.secret_string
}

resource "cloudflare_zone" "this" {
  account_id = var.account_id
  zone       = var.domain_name
}

resource "cloudflare_record" "ns" {
  count   = length(var.aws_route53_name_servers)
  zone_id = cloudflare_zone.this.id
  name    = var.domain_name
  type    = "NS"
  value   = element(var.aws_route53_name_servers, count.index)
  ttl     = 3600
}