output "record_id" {
  description = "Cloudflare DNS record ID for the SES inbound MX record."
  value       = cloudflare_dns_record.mx.id
}

output "record" {
  description = "Created SES inbound MX record details."
  value = {
    id       = cloudflare_dns_record.mx.id
    name     = cloudflare_dns_record.mx.name
    content  = cloudflare_dns_record.mx.content
    priority = cloudflare_dns_record.mx.priority
    proxied  = cloudflare_dns_record.mx.proxied
    ttl      = cloudflare_dns_record.mx.ttl
    type     = cloudflare_dns_record.mx.type
  }
}
