# SSM Parameter Placeholder

Creates an AWS SSM parameter with a placeholder value and `ignore_changes = [value]`, so the real value can be set out-of-band (console or CLI) without Terraform overwriting it on subsequent applies.

## Example

```hcl
module "cookie_secret" {
  source = "git::https://github.com/jch254/terraform-modules.git//ssm-parameter-placeholder?ref=1.11.0"

  name        = "/${var.name}/cookie-secret"
  description = "Secret key for cookie signing"

  tags = {
    Environment = var.environment
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the SSM parameter (e.g. `/my-app/cookie-secret`). | `string` | n/a | yes |
| `description` | Description for the SSM parameter. | `string` | `null` | no |
| `type` | Parameter type. One of `String`, `StringList`, `SecureString`. | `string` | `"SecureString"` | no |
| `placeholder_value` | Initial placeholder value written on creation. Subsequent changes to value are ignored. | `string` | `"placeholder"` | no |
| `tier` | Parameter tier (`Standard`, `Advanced`, `Intelligent-Tiering`). | `string` | `null` | no |
| `key_id` | Optional KMS key ID for SecureString parameters. | `string` | `null` | no |
| `tags` | Tags to apply to the parameter. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `name` | Name of the SSM parameter. |
| `arn` | ARN of the SSM parameter. |
| `version` | Version of the SSM parameter. |
