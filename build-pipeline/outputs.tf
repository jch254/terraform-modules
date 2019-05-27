output "artifacts_bucket_id" {
  value = var.artifact_store_s3_bucket != "" ? var.artifact_store_s3_bucket : aws_s3_bucket.artifacts[0].id
}
