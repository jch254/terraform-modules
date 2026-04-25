variable "domain" {
  description = "Domain to verify with Amazon SES, for example parse.example.com."
  type        = string
}

variable "tags" {
  description = "Reserved tag map for interface consistency. aws_ses_domain_identity and aws_ses_domain_dkim do not currently support tags in the AWS provider."
  type        = map(string)
  default     = {}
}
