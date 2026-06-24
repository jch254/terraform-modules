output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.main.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function."
  value       = aws_lambda_function.main.arn
}

output "log_group_name" {
  description = "Name of the Lambda CloudWatch log group."
  value       = aws_cloudwatch_log_group.lambda.name
}

output "api_id" {
  description = "ID of the HTTP API."
  value       = aws_apigatewayv2_api.main.id
}

output "api_arn" {
  description = "ARN of the HTTP API."
  value       = aws_apigatewayv2_api.main.arn
}

output "api_endpoint" {
  description = "Default endpoint of the HTTP API."
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "integration_id" {
  description = "ID of the API Gateway Lambda-proxy integration."
  value       = aws_apigatewayv2_integration.main.id
}

output "route_id" {
  description = "ID of the API Gateway route."
  value       = aws_apigatewayv2_route.main.id
}

output "stage_id" {
  description = "ID of the API Gateway stage."
  value       = aws_apigatewayv2_stage.main.id
}
