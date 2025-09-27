variable "source_dns_name" {
  description = "DNS Name to redirect from (e.g. source.example.com)"
  type        = string
}

variable "destination_dns_name" {
  description = "DNS name to redirect to (e.g. exampled.com)"
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID for source DNS name"
  type        = string
  default     = null
}

variable "acm_arn" {
  description = "ARN of ACM SSL certificate for source DNS name"
  type        = string
  default     = null
}
