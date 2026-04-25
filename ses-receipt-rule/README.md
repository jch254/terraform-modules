# ses-receipt-rule

Creates one Amazon SES receipt rule with an S3 action followed by a Lambda action.

This module models the shared SES inbound route shape currently used by Namaste and Lush:

- recipient domain match
- spam and virus scanning enabled
- TLS policy `Optional`
- raw MIME stored in S3
- app-specific Lambda forwarder invoked asynchronously
- optional rule ordering with `after`

This module intentionally does not manage receipt rule sets, active receipt rule sets, SES identities, DKIM, DNS records, raw mail buckets, bucket policies, Lambda forwarders, Lambda permissions, IAM roles, IAM policies, secrets, or app parser behavior.

## Examples

Namaste-style route:

```hcl
module "gtd_inbound_rule" {
  source = "git::https://github.com/jch254/terraform-modules.git//ses-receipt-rule?ref=<version>"

  name                = "gtd-inbound"
  rule_set_name       = module.ses_receipt_rule_set.name
  recipients          = ["parse.namasteapp.tech"]
  enabled             = true
  scan_enabled        = true
  tls_policy          = "Optional"
  s3_bucket_name      = "gtd-ses-emails"
  lambda_function_arn = "arn:aws:lambda:ap-southeast-2:352311918919:function:gtd-ses-forwarder"
}
```

Lush-style route ordered after Namaste:

```hcl
module "music_submission_rule" {
  source = "git::https://github.com/jch254/terraform-modules.git//ses-receipt-rule?ref=<version>"

  name                = "music-submission"
  rule_set_name       = module.ses_receipt_rule_set.name
  recipients          = ["parse.lushauraltreats.com"]
  enabled             = true
  scan_enabled        = true
  tls_policy          = "Optional"
  s3_bucket_name      = "lush-aural-treats-ses-emails"
  lambda_function_arn = "arn:aws:lambda:ap-southeast-2:352311918919:function:lush-aural-treats-ses-forwarder"
  after               = module.gtd_inbound_rule.name
}
```

The default action positions match the current live route shape: S3 at position `1`, Lambda at position `2`, Lambda invocation type `Event`.

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `name` | Name of the SES receipt rule. | `string` | required |
| `rule_set_name` | Name of the SES receipt rule set that owns this rule. | `string` | required |
| `recipients` | Recipient domains or addresses that this rule matches. | `list(string)` | required |
| `enabled` | Whether the SES receipt rule is enabled. | `bool` | `true` |
| `scan_enabled` | Whether SES spam and virus scanning is enabled for this rule. | `bool` | `true` |
| `tls_policy` | TLS policy for mail accepted by this receipt rule. Valid values are `Optional` or `Require`. | `string` | `"Optional"` |
| `s3_bucket_name` | S3 bucket name where SES stores raw inbound messages. | `string` | required |
| `s3_object_key_prefix` | Optional S3 object key prefix for raw inbound messages. | `string` | `""` |
| `lambda_function_arn` | ARN of the Lambda function invoked by the receipt rule. | `string` | required |
| `lambda_invocation_type` | Lambda invocation type for the SES action. Valid values are `Event` or `RequestResponse`. | `string` | `"Event"` |
| `after` | Optional receipt rule name that this rule should be placed after. | `string` | `null` |
| `s3_position` | Position of the S3 action in the SES receipt rule action list. | `number` | `1` |
| `lambda_position` | Position of the Lambda action in the SES receipt rule action list. | `number` | `2` |

## Outputs

| Name | Description |
| --- | --- |
| `name` | Name of the SES receipt rule. |
| `rule_set_name` | Name of the SES receipt rule set that owns this rule. |
| `id` | Terraform provider ID of the SES receipt rule. |

## Migration Notes

Existing live receipt rules must be imported or moved into `shared-ses-infra` state before applying this module. Do not let Terraform delete and recreate live rules during migration; a bad rule plan can interrupt inbound email.

Example imports for the current live shared rule set:

```bash
terraform import 'module.gtd_inbound_rule.aws_ses_receipt_rule.main' 'shared-inbound-mail-rules:gtd-inbound'
terraform import 'module.music_submission_rule.aws_ses_receipt_rule.main' 'shared-inbound-mail-rules:music-submission'
```

For Terraform-managed rules in the same state, prefer `moved` blocks or `terraform state mv`:

```hcl
moved {
  from = aws_ses_receipt_rule.namaste
  to   = module.gtd_inbound_rule.aws_ses_receipt_rule.main
}

moved {
  from = aws_ses_receipt_rule.lush
  to   = module.music_submission_rule.aws_ses_receipt_rule.main
}
```

After importing or moving state, run a plan and require no replacement. The live values to preserve are:

| Rule | Recipient | S3 bucket | Lambda |
| --- | --- | --- | --- |
| `gtd-inbound` | `parse.namasteapp.tech` | `gtd-ses-emails` | `arn:aws:lambda:ap-southeast-2:352311918919:function:gtd-ses-forwarder` |
| `music-submission` | `parse.lushauraltreats.com` | `lush-aural-treats-ses-emails` | `arn:aws:lambda:ap-southeast-2:352311918919:function:lush-aural-treats-ses-forwarder` |
