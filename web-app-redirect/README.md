# Web-app-redirect

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm_arn | ARN of ACM SSL certificate for source DNS name | string | - | yes |
| destination_dns_name | DNS name to redirect to (e.g. exampled.com) | string | - | yes |
| route53_zone_id | Route 53 Hosted Zone ID for source DNS name | string | - | yes |
| source_dns_name | DNS Name to redirect from (e.g. source.example.com) | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront_distribution_id |  |
| s3_bucket_id |  |
