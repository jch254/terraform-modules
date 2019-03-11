# Lambda-function

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| artifact_base64sha256 | Base64-encoded representation of raw SHA-256 sum of the Lambda function's artifact. Cannot be used with artifacts_dir variable. | string | `` | no |
| artifact_path | Path to the Lambda function's artifact. Cannot be used with artifacts_dir variable. | string | `` | no |
| artifacts_dir | Path to folder containing Lambda function's artifacts. Directory contents will be zipped. Cannot be used with artifact_path and artifact_base64sha256 variables. | string | `` | no |
| deployment_s3_bucket | The S3 bucket where the Lambda function will be deployed. If not provided an S3 bucket will be created. | string | `` | no |
| description | Description of what the Lambda Function does | string | `` | no |
| environment_variables | A map that defines environment variables for the Lambda function. E.g. [{ variables = { NAME = VALUE } }] | list | `<list>` | no |
| handler | The function that Lambda calls to begin execution | string | - | yes |
| log_retention | Specifies the number of days to retain log events | string | `7` | no |
| memory_size | Amount of memory in MB the Lambda Function can use at runtime | string | `128` | no |
| name | Name of Lambda function | string | - | yes |
| role_arn | IAM role attached to the Lambda Function | string | - | yes |
| runtime | Runtime environment for the Lambda function. See: https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime. | string | - | yes |
| schedule_expression | A valid rate or cron expression - see: http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html | string | `` | no |
| timeout | Amount of time in seconds the Lambda Function has to run | string | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_arn |  |

