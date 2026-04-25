output "record_ids" {
  description = "Cloudflare DNS record IDs keyed by validation record key."
  value = {
    for key, record in cloudflare_dns_record.acm_validation : key => record.id
  }
}

output "record_names" {
  description = "Cloudflare DNS record names keyed by validation record key."
  value = {
    for key, record in cloudflare_dns_record.acm_validation : key => record.name
  }
}

output "records" {
  description = "Created Cloudflare ACM validation DNS records keyed by validation record key."
  value = {
    for key, record in cloudflare_dns_record.acm_validation : key => {
      id      = record.id
      name    = record.name
      type    = record.type
      content = record.content
      ttl     = record.ttl
    }
  }
}
