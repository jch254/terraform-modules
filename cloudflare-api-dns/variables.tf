variable "zone_id" {
  description = "Cloudflare zone ID where API DNS records will be created."
  type        = string
}

variable "records" {
  description = "API Gateway CNAME records keyed by a stable caller-chosen key."
  type = map(object({
    name    = string
    target  = string
    proxied = optional(bool, true)
    ttl     = optional(number, 1)
  }))
}
