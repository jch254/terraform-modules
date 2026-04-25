output "verification_record_id" {
  description = "Cloudflare DNS record ID for the SES verification TXT record."
  value       = cloudflare_dns_record.verification.id
}

output "verification_record" {
  description = "Created SES verification TXT record details."
  value = {
    id      = cloudflare_dns_record.verification.id
    name    = cloudflare_dns_record.verification.name
    content = cloudflare_dns_record.verification.content
    proxied = cloudflare_dns_record.verification.proxied
    ttl     = cloudflare_dns_record.verification.ttl
    type    = cloudflare_dns_record.verification.type
  }
}

output "dkim_record_ids" {
  description = "Cloudflare DNS record IDs keyed by SES DKIM token."
  value = {
    for token, record in cloudflare_dns_record.dkim : token => record.id
  }
}

output "dkim_records" {
  description = "Created SES DKIM CNAME record details keyed by SES DKIM token."
  value = {
    for token, record in cloudflare_dns_record.dkim : token => {
      id      = record.id
      name    = record.name
      content = record.content
      proxied = record.proxied
      ttl     = record.ttl
      type    = record.type
    }
  }
}
