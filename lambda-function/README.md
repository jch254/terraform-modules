# Lambda-function

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| artifact\_base64sha256 | Base64-encoded representation of raw SHA-256 sum of the Lambda function's artifact. Cannot be used with artifacts_dir variable. | string | `""` | no |
| artifact\_path | Path to the Lambda function's artifact. Cannot be used with artifacts_dir variable. | string | `""` | no |
| artifacts\_dir | Path to folder containing Lambda function's artifacts. Directory contents will be zipped. Cannot be used with artifact_path and artifact_base64sha256 variables. | string | `""` | no |
| deployment\_s3\_bucket | The S3 bucket where the Lambda function will be deployed. If not provided an S3 bucket will be created. | string | `""` | no |
| description | Description of what the Lambda Function does | string | `""` | no |
| environment\_variables | A map that defines environment variables for the Lambda function. E.g. { NAME = "VALUE" } | map(string) | `{}` | no |
| handler | The function that Lambda calls to begin execution | string | n/a | yes |
| log\_retention | Specifies the number of days to retain log events | string | `"7"` | no |
| memory\_size | Amount of memory in MB the Lambda Function can use at runtime | string | `"128"` | no |
| name | Name of Lambda function | string | n/a | yes |
| role\_arn | IAM role attached to the Lambda Function | string | n/a | yes |
| runtime | Runtime environment for the Lambda function. See: https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime. | string | n/a | yes |
| schedule\_expression | A valid rate or cron expression - see: http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html | string | `""` | no |
| timeout | Amount of time in seconds the Lambda Function has to run | string | `"60"` | no |

## Outputs

| Name | Description |
|------|-------------|
| function |  |