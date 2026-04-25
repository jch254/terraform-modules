# cloudflare-api-dns

Creates Cloudflare CNAME records that route app hostnames to API Gateway custom domain targets.

This module intentionally does not manage ACM validation records, AWS resources, API Gateway resources, mail records, vendor verification records, Cloudflare security settings, redirects, rulesets, or tenant strategy. Callers decide which hostnames exist, whether each is proxied, and which API Gateway target each hostname uses.

## Example

```hcl
data "cloudflare_zone" "zone" {
  filter = {
    name = var.domain
  }
}

module "cloudflare_api_dns" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-api-dns?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  records = {
    main = {
      name    = var.subdomain
      target  = data.terraform_remote_state.aws.outputs.api_gateway_custom_domain_target
      proxied = true
      ttl     = 1
    }
  }
}
```

For apps with app-local apex and wildcard routing decisions, pass explicit records:

```hcl
records = {
  apex = {
    name    = "@"
    target  = data.terraform_remote_state.aws.outputs.api_gateway_apex_domain_target
    proxied = true
    ttl     = 1
  }
  wildcard = {
    name    = "*"
    target  = data.terraform_remote_state.aws.outputs.api_gateway_wildcard_domain_target
    proxied = true
    ttl     = 1
  }
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `zone_id` | Cloudflare zone ID where API DNS records will be created. | `string` | required |
| `records` | API Gateway CNAME records keyed by a stable caller-chosen key. | `map(object({ name = string, target = string, proxied = optional(bool, true), ttl = optional(number, 1) }))` | required |

## Outputs

| Name | Description |
| --- | --- |
| `record_ids` | Cloudflare DNS record IDs keyed by API DNS record key. |
| `record_names` | Cloudflare DNS record names keyed by API DNS record key. |
| `hostnames` | Cloudflare DNS record hostnames keyed by API DNS record key. |
| `records` | Created record details keyed by API DNS record key. |

## Migration Notes

Existing API routing DNS records must be moved into this module before applying. Record replacement or changes to `name`, `target`, `proxied`, `ttl`, `type`, or `zone_id` are not acceptable during migration.

Reference-architecture-style move target:

```hcl
moved {
  from = cloudflare_dns_record.main
  to   = module.cloudflare_api_dns.cloudflare_dns_record.cname["main"]
}
```

Equivalent state command:

```bash
terraform state mv 'cloudflare_dns_record.main' 'module.cloudflare_api_dns.cloudflare_dns_record.cname["main"]'
```

Preserve the caller's record keys and values exactly, including whether the record is proxied. Run a remote-state Cloudflare plan and require no create, update, delete, or replace for the moved records.
