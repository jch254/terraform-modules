output "s3_bucket_id" {
  description = "Name of the deployment S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "ARN of the deployment S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (e.g. dXXXX.cloudfront.net). Use as the target of CNAME records for any aliases."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Route 53 hosted zone ID for the CloudFront distribution (Z2FDTNDATAQYW2 globally). Useful for Route 53 alias records."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
