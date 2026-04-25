resource "cloudflare_dns_record" "mx" {
  content  = "inbound-smtp.${var.region}.amazonaws.com"
  name     = var.name
  priority = var.priority
  proxied  = false
  ttl      = var.ttl
  type     = "MX"
  zone_id  = var.zone_id
}
