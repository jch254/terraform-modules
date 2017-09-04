output "artifacts_bucket_id" {
  value = "${coalesce(var.artifact_store_s3_bucket, join("", aws_s3_bucket.artifacts.*.bucket))}"
}
