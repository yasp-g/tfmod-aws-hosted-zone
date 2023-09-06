output "hosted_zone_name_servers" {
  description = "The name serves for the hosted zone"
  value       = aws_route53_zone.primary.name_servers
}

output "certificate_arns" {
  description = "The ARN for each certificate"
  value       = [for c in aws_acm_certificate.cert : c.arn]
}

output "validation_options" {
  description = "The domain validation options of each certificate"
  value       = [for c in aws_acm_certificate.cert : c.domain_validation_options]
}