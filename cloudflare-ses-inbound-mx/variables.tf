variable "zone_id" {
  description = "Cloudflare zone ID where the SES inbound MX record will be created."
  type        = string
}

variable "name" {
  description = "DNS record name for the inbound SES domain, for example parse.example.com or parse."
  type        = string
}

variable "region" {
  description = "AWS region that receives inbound SES mail, for example ap-southeast-2."
  type        = string
}

variable "priority" {
  description = "MX record priority."
  type        = number
  default     = 10
}

variable "ttl" {
  description = "Cloudflare TTL for the SES inbound MX record. Use 1 for automatic TTL."
  type        = number
  default     = 1
}
