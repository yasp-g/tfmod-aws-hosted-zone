# Route 53 Variables
variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
}

variable "dkim_key" {
  description = "The DKIM key for the domain"
  type        = string
}

# SSL Variables
variable "needs_ssl" {
  description = "Whether to create an SSL certificate for the domain"
  type        = bool
  default     = true
}