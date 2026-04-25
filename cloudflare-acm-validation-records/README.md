# cloudflare-acm-validation-records

Creates Cloudflare DNS records for ACM DNS validation.

This module intentionally does not manage ACM certificates, AWS resources, API Gateway resources, app routing records, mail records, vendor verification records, Cloudflare security settings, redirects, rulesets, or tenant strategy.

## Example

```hcl
data "cloudflare_zone" "zone" {
  filter = {
    name = var.domain
  }
}

module "cloudflare_acm_validation_records" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudflare-acm-validation-records?ref=<version>"

  zone_id = data.cloudflare_zone.zone.id
  validation_records = {
    for key, record in data.terraform_remote_state.aws.outputs.acm_certificate_validation : key => {
      name    = record.name
      type    = record.type
      content = record.value
      ttl     = 1
    }
  }
}
```

If the AWS root already emits `content` instead of `value`, pass that field directly:

```hcl
validation_records = data.terraform_remote_state.aws.outputs.acm_certificate_validation_records
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `zone_id` | Cloudflare zone ID where validation records will be created. | `string` | required |
| `validation_records` | ACM DNS validation records keyed by a stable caller-chosen key. | `map(object({ name = string, type = string, content = string, ttl = optional(number, 1) }))` | required |

## Outputs

| Name | Description |
| --- | --- |
| `record_ids` | Cloudflare DNS record IDs keyed by validation record key. |
| `record_names` | Cloudflare DNS record names keyed by validation record key. |
| `records` | Created record details keyed by validation record key. |

## Migration Notes

Existing Cloudflare ACM validation records must be moved into this module before applying. Record replacement is not acceptable during migration.

Reference-architecture-style move target:

```hcl
moved {
  from = cloudflare_dns_record.acm_validation["reference-architecture.603.nz"]
  to   = module.cloudflare_acm_validation_records.cloudflare_dns_record.acm_validation["reference-architecture.603.nz"]
}
```

Equivalent state command:

```bash
terraform state mv 'cloudflare_dns_record.acm_validation["reference-architecture.603.nz"]' 'module.cloudflare_acm_validation_records.cloudflare_dns_record.acm_validation["reference-architecture.603.nz"]'
```

Preserve the caller's `for_each` keys, record `name`, `type`, `content`, `ttl`, and `zone_id` exactly. Run a remote-state Cloudflare plan and require no create, update, delete, or replace for the moved validation records.
