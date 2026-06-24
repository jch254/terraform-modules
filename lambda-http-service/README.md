# lambda-http-service

Container-image Lambda fronted by an API Gateway HTTP API (v2) with a Lambda
proxy integration. The HTTP-facing surface mirrors `ecs-http-service` — it emits
the same `api_id` / `stage_id` / `api_endpoint` outputs — so the same
`api-gateway-custom-domain` module and downstream DNS layer compose against
either compute backend unchanged.

Unlike `ecs-http-service`, there is no VPC Link, Cloud Map, or security group:
the function runs outside any VPC and API Gateway calls it through the managed
`AWS_PROXY` integration. The `$default` route + `$default` stage make the
function serve every method/path at the domain root (no stage prefix).

> The `lambda-function` module in this repo is zip/handler based and is a
> different primitive. This module is specifically for `package_type = "Image"`
> Lambdas. A container-image function cannot be **created** until its image
> already exists in ECR — stage the first image push before the first apply.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| name | Application name; used for the function, log group, and API names | string | n/a | yes |
| environment | Deployment environment tag value | string | `"prod"` | no |
| image | Full ECR image URI including tag; must already exist in ECR | string | n/a | yes |
| role\_arn | Lambda execution role ARN (logs + app DynamoDB/SSM access) | string | n/a | yes |
| description | Description of the Lambda function | string | `""` | no |
| memory\_size | Function memory in MB | number | `512` | no |
| timeout | Function timeout in seconds | number | `30` | no |
| architecture | `x86_64` or `arm64`; must match the image | string | `"x86_64"` | no |
| log\_retention\_in\_days | Lambda log group retention | number | `7` | no |
| environment\_variables | Function environment variables | map(string) | `{}` | no |
| route\_key | HTTP API route key | string | `"$default"` | no |
| stage\_name | HTTP API stage name | string | `"$default"` | no |
| auto\_deploy | Auto-deploy stage changes | bool | `true` | no |
| payload\_format\_version | Lambda-proxy payload format version | string | `"2.0"` | no |
| access\_log\_destination\_arn | Optional CloudWatch log group ARN for stage access logs | string | `null` | no |
| access\_log\_format | Optional stage access log format | string | `null` | no |
| tags | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_name | Name of the Lambda function |
| function\_arn | ARN of the Lambda function |
| log\_group\_name | Name of the Lambda CloudWatch log group |
| api\_id | ID of the HTTP API |
| api\_arn | ARN of the HTTP API |
| api\_endpoint | Default endpoint of the HTTP API |
| integration\_id | ID of the Lambda-proxy integration |
| route\_id | ID of the API Gateway route |
| stage\_id | ID of the API Gateway stage |
