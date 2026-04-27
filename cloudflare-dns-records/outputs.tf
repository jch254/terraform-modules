output "record_ids" {
  description = "Cloudflare DNS record IDs keyed by record key."
  value = {
    for key, record in cloudflare_dns_record.this : key => record.id
  }
}

output "record_names" {
  description = "Cloudflare DNS record names keyed by record key."
  value = {
    for key, record in cloudflare_dns_record.this : key => record.name
  }
}

output "records" {
  description = "Created Cloudflare DNS records keyed by record key."
  value = {
    for key, record in cloudflare_dns_record.this : key => {
      id       = record.id
      name     = record.name
      type     = record.type
      content  = record.content
      proxied  = record.proxied
      priority = record.priority
      ttl      = record.ttl
    }
  }
}
