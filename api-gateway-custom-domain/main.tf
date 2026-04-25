resource "aws_apigatewayv2_domain_name" "main" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = var.endpoint_type
    security_policy = var.security_policy
  }

  tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "main" {
  api_id      = var.api_id
  domain_name = aws_apigatewayv2_domain_name.main.id
  stage       = var.stage
}
