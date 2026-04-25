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

output "vpc_link_id" {
  description = "ID of the API Gateway VPC Link."
  value       = aws_apigatewayv2_vpc_link.main.id
}

output "integration_id" {
  description = "ID of the API Gateway integration."
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