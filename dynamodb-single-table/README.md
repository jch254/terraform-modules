# DynamoDB Single Table

Creates a DynamoDB table for the current single-table application pattern. The defaults match the reference architecture: `PAY_PER_REQUEST`, `PK`/`SK`, and TTL on `ttl`.

## Example

```hcl
module "entities" {
  source = "git::https://github.com/jch254/terraform-modules.git//dynamodb-single-table?ref=v0.2.0"

  name = "${var.name}-entities"

  tags = {
    Environment = var.environment
  }
}
```

## Example With Indexes

```hcl
module "entities" {
  source = "git::https://github.com/jch254/terraform-modules.git//dynamodb-single-table?ref=v0.2.0"

  name = "${var.name}-entities"

  attributes = [
    { name = "PK", type = "S" },
    { name = "SK", type = "S" },
    { name = "GSI1PK", type = "S" },
    { name = "GSI1SK", type = "S" },
  ]

  global_secondary_indexes = [
    {
      name      = "GSI1"
      hash_key  = "GSI1PK"
      range_key = "GSI1SK"
    },
  ]

  tags = {
    Environment = var.environment
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the DynamoDB table. | `string` | n/a | yes |
| `billing_mode` | DynamoDB billing mode. | `string` | `"PAY_PER_REQUEST"` | no |
| `hash_key` | Hash key attribute name. | `string` | `"PK"` | no |
| `range_key` | Range key attribute name. | `string` | `"SK"` | no |
| `attributes` | Table attributes used by the primary key and any secondary indexes. | `list(object)` | `PK`/`SK` string attributes | no |
| `global_secondary_indexes` | Global secondary indexes to create on the table. | `list(object)` | `[]` | no |
| `ttl_enabled` | Whether DynamoDB TTL is enabled. | `bool` | `true` | no |
| `ttl_attribute_name` | Attribute name used for TTL. | `string` | `"ttl"` | no |
| `tags` | Tags to apply to the table. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `table_name` | Name of the DynamoDB table. |
| `table_arn` | ARN of the DynamoDB table. |
| `table_id` | ID of the DynamoDB table. |
| `table_hash_key` | Hash key attribute name. |
| `table_range_key` | Range key attribute name. |