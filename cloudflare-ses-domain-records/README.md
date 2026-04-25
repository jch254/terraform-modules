# cloudflare-ses-domain-records

Creates Cloudflare DNS records required to verify an Amazon SES domain identity and enable Easy DKIM for that same domain.

Records are always unproxied. This module intentionally does not manage MX records, SPF, DMARC, Resend, iCloud, Apple verification, app routing records, Cloudflare security settings, AWS resources, receipt rules, or active receipt rule sets.

## Example

```hcl
module "parse_domain_records" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-ses-domain-records?ref=<version>"

  zone_id            = data.cloudflare_zone.zone.id
  domain             = "parse.example.com"
  verification_token = module.parse_domain_identity.verification_token
  dkim_tokens        = module.parse_domain_identity.dkim_tokens
  ttl                = 1
}
```

This creates:

- TXT `_amazonses.parse.example.com`
- CNAME `<token>._domainkey.parse.example.com` for each DKIM token

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `zone_id` | Cloudflare zone ID where SES identity and DKIM records will be created. | `string` | required |
| `domain` | SES identity domain, for example `parse.example.com`. | `string` | required |
| `verification_token` | SES domain verification token from `aws_ses_domain_identity`. | `string` | required |
| `dkim_tokens` | SES Easy DKIM tokens from `aws_ses_domain_dkim`. | `list(string)` | required |
| `ttl` | Cloudflare TTL for SES verification and DKIM records. Use `1` for automatic TTL. | `number` | `1` |

## Outputs

| Name | Description |
| --- | --- |
| `verification_record_id` | Cloudflare DNS record ID for the SES verification TXT record. |
| `verification_record` | Created SES verification TXT record details. |
| `dkim_record_ids` | Cloudflare DNS record IDs keyed by SES DKIM token. |
| `dkim_records` | Created SES DKIM CNAME record details keyed by SES DKIM token. |

## Migration Notes

Existing SES verification and DKIM DNS records must be imported or moved into this module before applying. Replacing DNS records can interrupt SES verification or DKIM signing.

Example import:

```bash
terraform import 'module.parse_domain_records.cloudflare_dns_record.verification' '<zone_id>/<record_id>'
terraform import 'module.parse_domain_records.cloudflare_dns_record.dkim["abc123"]' '<zone_id>/<record_id>'
```

For records already managed in the same Terraform state, prefer `moved` blocks or `terraform state mv`:

```hcl
moved {
  from = cloudflare_dns_record.ses_verification
  to   = module.parse_domain_records.cloudflare_dns_record.verification
}

moved {
  from = cloudflare_dns_record.ses_dkim["abc123._domainkey.parse.example.com"]
  to   = module.parse_domain_records.cloudflare_dns_record.dkim["abc123"]
}
```

Preserve record names, values, TTL, and `proxied = false`. Run a Cloudflare plan and require no create, update, delete, or replacement for migrated records.
