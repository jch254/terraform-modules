resource "cloudflare_dns_record" "this" {
  for_each = var.records

  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  proxied  = each.value.proxied
  priority = each.value.priority
  ttl      = each.value.ttl
  zone_id  = var.zone_id
}
