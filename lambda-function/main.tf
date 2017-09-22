data "archive_file" "artifacts" {
  count = "${var.artifacts_dir != "" ? 1 : 0}"

  type = "zip"
  source_dir = "${var.artifacts_dir}"
  output_path = "${var.artifacts_dir}/../artifacts.zip"
}

resource "aws_s3_bucket" "deployment" {
  count = "${var.deployment_s3_bucket == "" ? 1 : 0}"

  bucket_prefix = "${var.name}-deployment"
  acl = "private"
}

resource "aws_s3_bucket_object" "artifact" {
  count = "${var.artifact_path != "" ? 1 : 0}"
  
  bucket = "${coalesce(var.deployment_s3_bucket, join("", aws_s3_bucket.deployment.*.bucket))}"
  key = "${var.name}"
  source = "${var.artifact_path}"
  etag = "${md5(file(var.artifact_path))}"
}

resource "aws_s3_bucket_object" "zipped_artifacts" {
  count = "${var.artifacts_dir != "" ? 1 : 0}"
  
  bucket = "${coalesce(var.deployment_s3_bucket, join("", aws_s3_bucket.deployment.*.bucket))}"
  key = "${var.name}"
  source = "${var.artifacts_dir}/../artifacts.zip"
  etag = "${data.archive_file.artifacts.output_md5}"
}

resource "aws_cloudwatch_log_group" "lambda_lg" {
  name = "/aws/lambda/${var.name}"
  retention_in_days = "${var.log_retention}"
}

resource "aws_lambda_function" "function" {
  function_name = "${var.name}"
  s3_bucket = "${coalesce(var.deployment_s3_bucket, join("", aws_s3_bucket.deployment.*.id))}"  
  s3_key = "${coalesce(join("", aws_s3_bucket_object.artifact.*.id), join("", aws_s3_bucket_object.zipped_artifacts.*.id))}"
  runtime = "${var.runtime}"
  role = "${var.role_arn}"
  handler = "${var.handler}"
  source_code_hash = "${coalesce(join("", data.archive_file.artifacts.*.output_base64sha256), var.artifact_base64sha256)}"
  description = "${var.description}"
  memory_size = "${var.memory_size}"
  timeout = "${var.timeout}"
  environment = "${var.environment_variables}"
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  count = "${var.schedule_expression != "" ? 1 : 0}"
  
  name = "${var.name}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_lambda_permission" "lambda_permission" {
  count = "${var.schedule_expression != "" ? 1 : 0}"

  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.arn}"
  principal  = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.event_rule.arn}"
  depends_on = ["aws_cloudwatch_event_rule.event_rule"]
}

resource "aws_cloudwatch_event_target" "event_target" {
  count = "${var.schedule_expression != "" ? 1 : 0}"

  target_id = "${var.name}"
  rule = "${aws_cloudwatch_event_rule.event_rule.name}"
  arn = "${aws_lambda_function.function.arn}"
  depends_on = ["aws_cloudwatch_event_rule.event_rule"]
}
