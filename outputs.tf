output "hosted_zone_name_servers" {
  description = "The name serves for the hosted zone"
  value       = aws_route53_zone.primary.name_servers
}

output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.cert.arn
}

output "validation_options" {
  description = "The domain validation options of the certificate"
  value       = aws_acm_certificate.cert.domain_validation_options
}