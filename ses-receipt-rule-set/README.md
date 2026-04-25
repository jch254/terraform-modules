# ses-receipt-rule-set

Creates one Amazon SES receipt rule set, with optional activation.

**Important:** SES allows exactly one active receipt rule set per AWS account and region. Activating a product-local rule set can break inbound mail for every other app in that region.

`activate` defaults to `false`. The only intended place to set `activate = true` is the shared SES owner root, currently `shared-ses-infra`, after every live inbound domain in that account/region is represented in the shared model.

This module intentionally does not manage receipt rules, SES identities, DKIM, DNS records, raw mail buckets, bucket policies, Lambda forwarders, Lambda permissions, IAM, or app parser behavior.

## Example

```hcl
module "ses_receipt_rule_set" {
  source = "git::https://github.com/jch254/terraform-modules.git//ses-receipt-rule-set?ref=<version>"

  name     = "shared-inbound-mail-rules"
  activate = false
}
```

Only the shared SES owner root should enable activation:

```hcl
module "ses_receipt_rule_set" {
  source = "git::https://github.com/jch254/terraform-modules.git//ses-receipt-rule-set?ref=<version>"

  name     = "shared-inbound-mail-rules"
  activate = true
}
```

Before enabling activation, verify the plan preserves every live inbound route.

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `name` | Name of the SES receipt rule set. | `string` | required |
| `activate` | Whether to make this receipt rule set active in the current AWS account and region. | `bool` | `false` |

## Outputs

| Name | Description |
| --- | --- |
| `name` | Name of the SES receipt rule set. |
| `id` | Terraform provider ID of the SES receipt rule set. |
| `active_rule_set_name` | Active receipt rule set name when `activate` is true, otherwise null. |

## Migration Notes

Existing receipt rule sets must be imported or moved into the shared owner state before applying this module. Do not let Terraform destroy, recreate, or switch the active rule set during migration.

Example import:

```bash
terraform import 'module.ses_receipt_rule_set.aws_ses_receipt_rule_set.main' shared-inbound-mail-rules
terraform import 'module.ses_receipt_rule_set.aws_ses_active_receipt_rule_set.main[0]' shared-inbound-mail-rules
```

For a Terraform-managed rule set in the same state, prefer `moved` blocks or `terraform state mv`:

```hcl
moved {
  from = aws_ses_receipt_rule_set.regional
  to   = module.ses_receipt_rule_set.aws_ses_receipt_rule_set.main
}

moved {
  from = aws_ses_active_receipt_rule_set.regional
  to   = module.ses_receipt_rule_set.aws_ses_active_receipt_rule_set.main[0]
}
```

Run a plan after moving or importing state and require no replacement. For shared SES routing, also verify:

```bash
aws ses describe-active-receipt-rule-set --region ap-southeast-2
```
