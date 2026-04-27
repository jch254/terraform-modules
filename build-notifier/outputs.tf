output "sns_topic_arn" {
  description = "ARN of the SNS topic that receives formatted build notifications."
  value       = aws_sns_topic.this.arn
}

output "lambda_function_name" {
  description = "Name of the formatter Lambda function."
  value       = aws_lambda_function.formatter.function_name
}

output "lambda_function_arn" {
  description = "ARN of the formatter Lambda function."
  value       = aws_lambda_function.formatter.arn
}

output "event_rule_arn" {
  description = "ARN of the EventBridge rule listening on CodeBuild state changes."
  value       = aws_cloudwatch_event_rule.this.arn
}
