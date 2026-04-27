locals {
  github_repo_url = trimsuffix(var.github_repo_url, ".git")
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = "${var.name}-build-notifications"
  description = "CodeBuild build success and failure events for ${var.name}"

  event_pattern = jsonencode({
    source      = ["aws.codebuild"]
    detail-type = ["CodeBuild Build State Change"]
    detail = {
      build-status = ["SUCCEEDED", "FAILED"]
      project-name = var.codebuild_project_names
    }
  })

  tags = {
    Name        = "${var.name}-build-notifications"
    Environment = var.environment
  }
}

resource "aws_lambda_permission" "eventbridge" {
  statement_id  = "Allow-${var.name}-BuildNotifications"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "${var.name}-build-notifications-lambda"
  arn       = var.lambda_function_arn

  input_transformer {
    input_template = <<TEMPLATE
{
  "event": <aws.events.event.json>,
  "appUrl": ${jsonencode(var.app_url)},
  "githubRepoUrl": ${jsonencode(local.github_repo_url)}
}
TEMPLATE
  }
}
