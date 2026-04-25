output "name" {
  description = "Name of the CloudWatch log group."
  value       = aws_cloudwatch_log_group.main.name
}

output "arn" {
  description = "ARN of the CloudWatch log group."
  value       = aws_cloudwatch_log_group.main.arn
}