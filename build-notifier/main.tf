resource "aws_sns_topic" "this" {
  name = "${var.name}-build-notifications"

  tags = {
    Name        = "${var.name}-build-notifications"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_iam_role" "lambda" {
  name = "${var.name}-build-notification-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.name}-build-notification-lambda"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.name}-build-notification-lambda"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = aws_sns_topic.this.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/dist/index.js"
  output_path = "${path.module}/lambda/dist/build-notification-formatter.zip"
}

resource "aws_lambda_function" "formatter" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "${var.name}-build-notification-formatter"
  role             = aws_iam_role.lambda.arn
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN   = aws_sns_topic.this.arn
      APP_URL         = var.app_url
      GITHUB_REPO_URL = var.github_repo_url
    }
  }

  tags = {
    Name        = "${var.name}-build-notification-formatter"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_event_rule" "this" {
  count = length(var.codebuild_project_names) > 0 ? 1 : 0

  name        = "${var.name}-build-notifications"
  description = "CodeBuild build success and failure events"

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
  count = length(var.codebuild_project_names) > 0 ? 1 : 0

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.formatter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this[0].arn
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = length(var.codebuild_project_names) > 0 ? 1 : 0

  rule      = aws_cloudwatch_event_rule.this[0].name
  target_id = "${var.name}-build-notifications-lambda"
  arn       = aws_lambda_function.formatter.arn
}
