variable "zone_id" {
  description = "Cloudflare zone ID where ACM validation records will be created."
  type        = string
}

variable "validation_records" {
  description = "ACM DNS validation records keyed by a stable caller-chosen key."
  type = map(object({
    name    = string
    type    = string
    content = string
    ttl     = optional(number, 1)
  }))
}
