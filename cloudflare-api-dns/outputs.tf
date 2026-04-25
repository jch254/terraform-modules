output "record_ids" {
  description = "Cloudflare DNS record IDs keyed by API DNS record key."
  value = {
    for key, record in cloudflare_dns_record.cname : key => record.id
  }
}

output "record_names" {
  description = "Cloudflare DNS record names keyed by API DNS record key."
  value = {
    for key, record in cloudflare_dns_record.cname : key => record.name
  }
}

output "hostnames" {
  description = "Cloudflare DNS record hostnames keyed by API DNS record key."
  value = {
    for key, record in cloudflare_dns_record.cname : key => record.name
  }
}

output "records" {
  description = "Created Cloudflare API DNS records keyed by API DNS record key."
  value = {
    for key, record in cloudflare_dns_record.cname : key => {
      id       = record.id
      name     = record.name
      hostname = record.name
      target   = record.content
      proxied  = record.proxied
      ttl      = record.ttl
      type     = record.type
    }
  }
}
