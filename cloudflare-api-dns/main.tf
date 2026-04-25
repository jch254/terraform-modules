resource "cloudflare_dns_record" "cname" {
  for_each = var.records

  content = each.value.target
  name    = each.value.name
  proxied = each.value.proxied
  ttl     = each.value.ttl
  type    = "CNAME"
  zone_id = var.zone_id
}
