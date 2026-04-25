resource "cloudflare_dns_record" "acm_validation" {
  for_each = var.validation_records

  content = each.value.content
  name    = each.value.name
  proxied = false
  ttl     = each.value.ttl
  type    = each.value.type
  zone_id = var.zone_id
}
