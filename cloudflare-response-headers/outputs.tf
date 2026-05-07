output "id" {
  description = "Cloudflare response-header ruleset ID."
  value       = cloudflare_ruleset.this.id
}

output "name" {
  description = "Cloudflare response-header ruleset name."
  value       = cloudflare_ruleset.this.name
}

output "phase" {
  description = "Cloudflare ruleset phase."
  value       = cloudflare_ruleset.this.phase
}
