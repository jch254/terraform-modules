# ECR Repository

Creates an Amazon ECR repository using the current ECS application pattern: mutable tags and image scanning on push by default.

## Example

```hcl
module "ecr" {
  source = "git::https://github.com/jch254/terraform-modules.git//ecr-repository?ref=1.1.0"

  name = var.name

  tags = {
    Environment = var.environment
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the ECR repository. | `string` | n/a | yes |
| `image_tag_mutability` | Tag mutability setting for the repository. | `string` | `"MUTABLE"` | no |
| `scan_on_push` | Whether images are scanned after being pushed. | `bool` | `true` | no |
| `force_delete` | Whether to delete the repository even if it contains images. | `bool` | `false` | no |
| `lifecycle_policy_json` | Optional ECR lifecycle policy JSON. | `string` | `null` | no |
| `tags` | Tags to apply to repository resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `repository_name` | Name of the ECR repository. |
| `repository_arn` | ARN of the ECR repository. |
| `repository_url` | URL of the ECR repository. |
| `registry_id` | Registry ID that hosts the repository. |