# lambda-runtime-iam

Single IAM execution role for a container-image Lambda, the Lambda-trust analogue
of `app-runtime-iam` (which is ECS-task trust and produces two roles). Grants:

- CloudWatch Logs via the managed `AWSLambdaBasicExecutionRole`.
- The app DynamoDB actions on the table and its indexes.
- `ssm:GetParameters` + scoped `kms:Decrypt` so the function can resolve
  SecureString secrets (e.g. `COOKIE_SECRET`) at cold start. Omitted when
  `ssm_parameter_arns` is empty.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| name | Application name; used in the role/policy names | string | n/a | yes |
| environment | Deployment environment tag value | string | `"prod"` | no |
| region | AWS region for the SSM KMS ViaService condition | string | n/a | yes |
| ssm\_parameter\_arns | SSM parameter ARNs the Lambda may read; empty disables the SSM policy | list(string) | `[]` | no |
| dynamodb\_table\_arn | DynamoDB table ARN the Lambda may access | string | n/a | yes |
| dynamodb\_actions | DynamoDB actions for the table and indexes | list(string) | GetItem, PutItem, UpdateItem, DeleteItem, BatchWriteItem, Query, DescribeTable | no |
| tags | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role\_arn | ARN of the Lambda execution role |
| role\_name | Name of the Lambda execution role |
