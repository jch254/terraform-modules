# web-app

Static SPA hosting on S3 (private, BucketOwnerEnforced) fronted by a
CloudFront distribution that authenticates to S3 via Origin Access Control.

DNS is the caller's responsibility — the module exposes
`cloudfront_domain_name` so the caller can wire up Route 53, Cloudflare, or
any other DNS provider as a CNAME / alias.

When `dns_names` is non-empty, the caller must pass a us-east-1 ACM
certificate ARN covering all of those names. CloudFront will not accept
custom aliases without one.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Deployment S3 bucket name and CloudFront origin id. | string | n/a | yes |
| dns_names | CloudFront alias CNAMEs. | list(string) | `[]` | no |
| acm_arn | us-east-1 ACM certificate ARN. Required when `dns_names` is non-empty. | string | `null` | conditional |
| price_class | CloudFront price class. | string | `PriceClass_All` | no |
| default_root_object | Object served at the distribution root. | string | `index.html` | no |
| spa_fallback_path | Path returned with HTTP 200 for 403/404 responses (set empty to disable). | string | `/index.html` | no |
| force_destroy | Force-destroy the S3 bucket on destroy. | bool | `true` | no |
| tags | Additional resource tags. | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_bucket_id | Deployment S3 bucket name. |
| s3_bucket_arn | Deployment S3 bucket ARN. |
| cloudfront_distribution_id | CloudFront distribution ID (use for invalidations). |
| cloudfront_distribution_arn | CloudFront distribution ARN. |
| cloudfront_domain_name | CloudFront distribution domain (CNAME target). |
| cloudfront_hosted_zone_id | CloudFront global hosted zone ID for Route 53 alias records. |
