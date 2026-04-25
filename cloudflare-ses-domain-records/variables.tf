variable "zone_id" {
  description = "Cloudflare zone ID where SES identity and DKIM records will be created."
  type        = string
}

variable "domain" {
  description = "SES identity domain, for example parse.example.com."
  type        = string
}

variable "verification_token" {
  description = "SES domain verification token from aws_ses_domain_identity."
  type        = string
}

variable "dkim_tokens" {
  description = "SES Easy DKIM tokens from aws_ses_domain_dkim."
  type        = list(string)
}

variable "ttl" {
  description = "Cloudflare TTL for SES verification and DKIM records. Use 1 for automatic TTL."
  type        = number
  default     = 1
}
