variable "zone_id" {
  description = "Cloudflare zone ID where DNS records will be created."
  type        = string
}

variable "records" {
  description = "Cloudflare DNS records keyed by a stable caller-chosen key. Use `priority` for MX/SRV/URI records and `proxied` for proxiable A/AAAA/CNAME records."
  type = map(object({
    name     = string
    type     = string
    content  = string
    proxied  = optional(bool, false)
    priority = optional(number)
    ttl      = optional(number, 1)
  }))
}
