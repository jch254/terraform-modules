# Web-app-redirect

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm\_arn | ARN of ACM SSL certificate for source DNS name | string | n/a | yes |
| destination\_dns\_name | DNS name to redirect to (e.g. exampled.com) | string | n/a | yes |
| route53\_zone\_id | Route 53 Hosted Zone ID for source DNS name | string | n/a | yes |
| source\_dns\_name | DNS Name to redirect from (e.g. source.example.com) | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront\_distribution\_id |  |
| s3\_bucket\_id |  |
