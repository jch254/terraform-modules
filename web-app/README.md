# Web-app

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm\_arn | ARN of ACM SSL certificate | string | null | no |
| bucket\_name | Name of deployment S3 bucket | string | n/a | yes |
| dns\_names | List of DNS names for app | list(string) | `[]` | no |
| route53\_zone\_id | Route 53 Hosted Zone ID | string | null | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront\_distribution\_id |  |
| s3\_bucket\_id |  |
