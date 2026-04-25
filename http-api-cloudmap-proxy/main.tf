locals {
  api_tags = merge(
    {
      Name        = "${var.name}-api"
      Environment = var.environment
    },
    var.tags,
  )

  vpc_link_tags = merge(
    {
      Name        = "${var.name}-vpc-link"
      Environment = var.environment
    },
    var.tags,
  )

  stage_tags = merge(
    {
      Name        = "${var.name}-api-stage"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_apigatewayv2_api" "main" {
  name          = "${var.name}-api"
  protocol_type = "HTTP"

  tags = local.api_tags
}

resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.name}-vpc-link"
  security_group_ids = var.vpc_link_security_group_ids
  subnet_ids         = var.subnet_ids

  tags = local.vpc_link_tags
}

resource "aws_apigatewayv2_integration" "main" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = var.cloudmap_service_arn
  integration_method = var.integration_method
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.main.id
}

resource "aws_apigatewayv2_route" "main" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy

  tags = local.stage_tags
}