output "s3_bucket_id" {
  value = aws_s3_bucket.redirect_bucket.id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}
