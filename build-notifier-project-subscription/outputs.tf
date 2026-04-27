output "event_rule_arn" {
  description = "ARN of the EventBridge rule listening on CodeBuild state changes."
  value       = aws_cloudwatch_event_rule.this.arn
}

output "event_rule_name" {
  description = "Name of the EventBridge rule listening on CodeBuild state changes."
  value       = aws_cloudwatch_event_rule.this.name
}
