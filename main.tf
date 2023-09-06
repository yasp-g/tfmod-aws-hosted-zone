terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

# ROUTE 53
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# gmail records
resource "aws_route53_record" "mx" {
  count   = var.needs_email ? 1 : 0
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = 300

  records = var.mx_records
}

resource "aws_route53_record" "spf" {
  count   = var.needs_email ? 1 : 0
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 300

  records = [var.spf_records]
}

resource "aws_route53_record" "dkim" {
  count   = var.needs_email ? 1 : 0
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.dkim_selector}.${var.domain_name}"
  type    = "TXT"
  ttl     = 300

  records = [
    "v=DKIM1;",
    "k=rsa;",
    "p=${var.dkim_key}"
  ]
}

# SSl Certificate
resource "aws_acm_certificate" "cert" {
  count              = var.needs_ssl ? 1 : 0
  domain_name        = "*.${var.domain_name}"
  validation_method  = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  count                   = var.needs_ssl ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_acm_certificate.cert[0].domain_validation_options : record.resource_record_name]
}

resource "aws_route53_record" "validation" {
  count   = var.needs_ssl ? length(aws_acm_certificate.cert[0].domain_validation_options) : 0
  name    = element(aws_acm_certificate.cert[0].domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.cert[0].domain_validation_options.*.resource_record_type, count.index)
  zone_id = aws_route53_zone.primary.zone_id
  records = [element(aws_acm_certificate.cert[0].domain_validation_options.*.resource_record_value, count.index)]
  ttl     = 60
}