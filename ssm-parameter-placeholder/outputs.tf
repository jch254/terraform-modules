output "name" {
  description = "Name of the SSM parameter."
  value       = aws_ssm_parameter.main.name
}

output "arn" {
  description = "ARN of the SSM parameter."
  value       = aws_ssm_parameter.main.arn
}

output "version" {
  description = "Version of the SSM parameter."
  value       = aws_ssm_parameter.main.version
}
