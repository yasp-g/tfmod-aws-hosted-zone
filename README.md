# Module Purpose
Terraform module for provisioning a hosted zone in aws with or without an associated SSL certificate.

## Provider
hashicorp/aws 5.1.0

# Module Resources
- `aws_route53_zone`
- `aws_route53_record`
  - For `mx`, `spf`, `dkim` and SSL certificate
- `aws_acm_certificate`
- `aws_acm_certificate_validation`
- `aws_route53_record`

# Variables
- `domain_name`
- `dkim_key`
- `needs_ssl`

# Outputs
- `hosted_zone_name_servers`
- `certificate_arn`
- `validation_options`