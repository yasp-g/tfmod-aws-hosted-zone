# Route 53 Variables
variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
}

# Email Variables
variable "needs_email" {
  description = "Whether to set up email for the domain"
  type        = bool
  default     = false
}

variable "mx_records" {
  description = "The MX records for the email provider"
  type        = list(string)
}

variable "spf_records" {
  description = "The SPF record for the email provider"
  type        = string
}

variable "dkim_selector" {
  description = "The DKIM selector for the email provider"
  type        = string
}

variable "dkim_key" {
  description = "The DKIM key for the email provider"
  type        = string
}

# SSL Variables
variable "needs_ssl" {
  description = "Whether to create an SSL certificate for the domain"
  type        = bool
  default     = true
}