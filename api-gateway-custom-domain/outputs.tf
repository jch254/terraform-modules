output "domain_name" {
  description = "API Gateway custom domain name."
  value       = aws_apigatewayv2_domain_name.main.domain_name
}

output "target_domain_name" {
  description = "Regional API Gateway target domain name for DNS CNAME records."
  value       = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].target_domain_name
}

output "hosted_zone_id" {
  description = "API Gateway hosted zone ID for the custom domain target."
  value       = aws_apigatewayv2_domain_name.main.domain_name_configuration[0].hosted_zone_id
}

output "api_mapping_id" {
  description = "ID of the API Gateway API mapping."
  value       = aws_apigatewayv2_api_mapping.main.id
}
