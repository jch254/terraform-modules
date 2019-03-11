# Web-app

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm_arn | ARN of ACM SSL certificate | string | - | yes |
| bucket_name | Name of deployment S3 bucket | string | - | yes |
| dns_names | List of DNS names for app | list | - | yes |
| route53_zone_id | Route 53 Hosted Zone ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront_distribution_id |  |
| s3_bucket_id |  |
