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
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = 300

  records = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM."
  ]
}

resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 300

  records = [
    "v=spf1 include:_spf.google.com ~all"
  ]
}

resource "aws_route53_record" "dkim1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "google._domainkey.${var.domain_name}"
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