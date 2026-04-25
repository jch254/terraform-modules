resource "aws_ses_receipt_rule" "main" {
  name          = var.name
  rule_set_name = var.rule_set_name
  recipients    = var.recipients
  enabled       = var.enabled
  scan_enabled  = var.scan_enabled
  tls_policy    = var.tls_policy
  after         = var.after

  s3_action {
    bucket_name       = var.s3_bucket_name
    object_key_prefix = var.s3_object_key_prefix != "" ? var.s3_object_key_prefix : null
    position          = var.s3_position
  }

  lambda_action {
    function_arn    = var.lambda_function_arn
    invocation_type = var.lambda_invocation_type
    position        = var.lambda_position
  }
}
