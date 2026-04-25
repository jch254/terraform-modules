# cloudflare-ses-inbound-mx

Creates one Cloudflare MX record that routes an inbound parse domain to Amazon SES receiving.

The record is always unproxied and points at `inbound-smtp.<region>.amazonaws.com`. This module intentionally does not manage SES verification TXT records, DKIM CNAME records, SPF, DMARC, Resend, iCloud, Apple verification, app routing records, Cloudflare security settings, AWS resources, receipt rules, or active receipt rule sets.

## Example

```hcl
module "parse_inbound_mx" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-ses-inbound-mx?ref=<version>"

  zone_id  = data.cloudflare_zone.zone.id
  name     = "parse.example.com"
  region   = "ap-southeast-2"
  priority = 10
  ttl      = 1
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `zone_id` | Cloudflare zone ID where the SES inbound MX record will be created. | `string` | required |
| `name` | DNS record name for the inbound SES domain, for example `parse.example.com` or `parse`. | `string` | required |
| `region` | AWS region that receives inbound SES mail, for example `ap-southeast-2`. | `string` | required |
| `priority` | MX record priority. | `number` | `10` |
| `ttl` | Cloudflare TTL for the SES inbound MX record. Use `1` for automatic TTL. | `number` | `1` |

## Outputs

| Name | Description |
| --- | --- |
| `record_id` | Cloudflare DNS record ID for the SES inbound MX record. |
| `record` | Created SES inbound MX record details. |

## Migration Notes

Existing inbound MX records must be imported or moved into this module before applying. Replacing or removing the MX record can stop inbound email delivery for the parse domain.

Example import:

```bash
terraform import 'module.parse_inbound_mx.cloudflare_dns_record.mx' '<zone_id>/<record_id>'
```

For records already managed in the same Terraform state, prefer a `moved` block or `terraform state mv`:

```hcl
moved {
  from = cloudflare_dns_record.ses_inbound_mx
  to   = module.parse_inbound_mx.cloudflare_dns_record.mx
}
```

Preserve record name, target, priority, TTL, and `proxied = false`. Run a Cloudflare plan and require no create, update, delete, or replacement for migrated records.
