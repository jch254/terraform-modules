resource "cloudflare_dns_record" "verification" {
  content = var.verification_token
  name    = "_amazonses.${var.domain}"
  proxied = false
  ttl     = var.ttl
  type    = "TXT"
  zone_id = var.zone_id
}

resource "cloudflare_dns_record" "dkim" {
  for_each = toset(var.dkim_tokens)

  content = "${each.value}.dkim.amazonses.com"
  name    = "${each.value}._domainkey.${var.domain}"
  proxied = false
  ttl     = var.ttl
  type    = "CNAME"
  zone_id = var.zone_id
}
