# cloudflare-dns-records

Creates Cloudflare DNS records from a single typed map. Replaces the per-purpose modules `cloudflare-acm-validation-records`, `cloudflare-api-dns`, `cloudflare-ses-domain-records`, and `cloudflare-ses-inbound-mx`.

This module is intentionally a thin records-as-data wrapper. Callers compose record names and contents (including SES-specific values like `_amazonses.<domain>`, `<token>._domainkey.<domain>`, and `inbound-smtp.<region>.amazonaws.com`) and pass them in via `records`. The module does not assume a purpose.

## Example: ACM validation records

```hcl
module "acm_validation" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-dns-records?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  records = {
    for key, record in module.acm_certificate.validation_records : key => {
      name    = record.name
      type    = record.type
      content = record.content
      ttl     = 1
    }
  }
}
```

## Example: API Gateway CNAMEs

```hcl
module "api_dns" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-dns-records?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  records = {
    main = {
      name    = var.subdomain
      type    = "CNAME"
      content = data.terraform_remote_state.aws.outputs.api_gateway_custom_domain_target
      proxied = true
    }
  }
}
```

## Example: SES domain identity (verification + DKIM)

```hcl
locals {
  ses_records = merge(
    {
      verification = {
        name    = "_amazonses.${var.domain}"
        type    = "TXT"
        content = module.ses_identity.verification_token
      }
    },
    {
      for token in module.ses_identity.dkim_tokens :
      "dkim_${token}" => {
        name    = "${token}._domainkey.${var.domain}"
        type    = "CNAME"
        content = "${token}.dkim.amazonses.com"
      }
    },
  )
}

module "ses_dns" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-dns-records?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  records = local.ses_records
}
```

## Example: SES inbound MX

```hcl
module "ses_inbound_mx" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-dns-records?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  records = {
    inbound = {
      name     = var.inbound_subdomain
      type     = "MX"
      content  = "inbound-smtp.${var.aws_region}.amazonaws.com"
      priority = 10
    }
  }
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `zone_id` | Cloudflare zone ID where DNS records will be created. | `string` | required |
| `records` | DNS records keyed by a stable caller-chosen key. | `map(object({ name = string, type = string, content = string, proxied = optional(bool, false), priority = optional(number), ttl = optional(number, 1) }))` | required |

`priority` only applies to MX/SRV/URI records. `proxied` only applies to proxiable A/AAAA/CNAME records.

## Outputs

| Name | Description |
| --- | --- |
| `record_ids` | Cloudflare DNS record IDs keyed by record key. |
| `record_names` | Cloudflare DNS record names keyed by record key. |
| `records` | Created record details keyed by record key. |

## Migration from the previous per-purpose modules

The resource address inside this module is `cloudflare_dns_record.this[<key>]`. Move state from the old modules without recreating records.

From `cloudflare-acm-validation-records`:

```hcl
moved {
  from = module.cloudflare_acm_validation.cloudflare_dns_record.acm_validation["<key>"]
  to   = module.acm_validation.cloudflare_dns_record.this["<key>"]
}
```

From `cloudflare-api-dns`:

```hcl
moved {
  from = module.cloudflare_api_dns.cloudflare_dns_record.cname["<key>"]
  to   = module.api_dns.cloudflare_dns_record.this["<key>"]
}
```

From `cloudflare-ses-domain-records` (verification TXT + per-token DKIM CNAMEs):

```hcl
moved {
  from = module.cloudflare_ses_domain_records.cloudflare_dns_record.verification
  to   = module.ses_dns.cloudflare_dns_record.this["verification"]
}

moved {
  from = module.cloudflare_ses_domain_records.cloudflare_dns_record.dkim["<token>"]
  to   = module.ses_dns.cloudflare_dns_record.this["dkim_<token>"]
}
```

From `cloudflare-ses-inbound-mx`:

```hcl
moved {
  from = module.cloudflare_ses_inbound_mx.cloudflare_dns_record.mx
  to   = module.ses_inbound_mx.cloudflare_dns_record.this["inbound"]
}
```

Run a remote-state Cloudflare plan after moves and require no create, update, delete, or replace for moved records. Keys, names, contents, `proxied`, `priority`, and `ttl` must match the prior values exactly.
