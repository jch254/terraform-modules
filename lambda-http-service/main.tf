locals {
  tags = merge(
    {
      Name        = var.name
      Environment = var.environment
    },
    var.tags,
  )

  api_tags = merge(
    {
      Name        = "${var.name}-api"
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

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_in_days
  tags              = local.tags
}

# Container-image Lambda. The image must already exist in ECR before this is
# created — unlike an ECS task definition, a package_type = "Image" function
# cannot be created against a missing image (see the root README bootstrap).
resource "aws_lambda_function" "main" {
  function_name = var.name
  description   = var.description
  role          = var.role_arn
  package_type  = "Image"
  image_uri     = var.image
  memory_size   = var.memory_size
  timeout       = var.timeout
  architectures = [var.architecture]

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  tags = local.tags

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_apigatewayv2_api" "main" {
  name          = "${var.name}-api"
  protocol_type = "HTTP"

  tags = local.api_tags
}

resource "aws_apigatewayv2_integration" "main" {
  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.main.invoke_arn
  payload_format_version = var.payload_format_version
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

  dynamic "access_log_settings" {
    for_each = var.access_log_destination_arn == null ? [] : [1]

    content {
      destination_arn = var.access_log_destination_arn
      format          = var.access_log_format
    }
  }

  tags = local.stage_tags
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
