# Module Purpose
Terraform module for provisioning a hosted zone in aws with or without an associated SSL certificate. Provides MX records for gmail.

## Provider
hashicorp/aws 5.1.0

# Example
```hcl
module "hosted_zone" {
  source = "git::https://github.com/yasp-g/tfmod-aws-hosted-zone.git"

  domain_name   = <your_domain>
  needs_ssl     = true
  needs_email   = true
  mx_records    = [
    "10 mail.protonmail.ch.",
    "20 mailsec.protonmail.ch."
  ]
  spf_records   = "v=spf1 include:_spf.protonmail.ch mx ~all"
  dkim_selector = "protonmail._domainkey"
  dkim_key      = <your_dkim_key_for_protonmail>
}
```

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