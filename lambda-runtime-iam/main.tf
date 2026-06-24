locals {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  role_tags = merge(
    {
      Name        = "${var.name}-lambda-role"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_iam_role" "lambda" {
  name               = "${var.name}-lambda-role"
  assume_role_policy = local.assume_role_policy

  tags = local.role_tags
}

# CloudWatch Logs (create group/stream + put events) for the function.
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "dynamodb" {
  name = "${var.name}-lambda-dynamodb"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = var.dynamodb_actions
        Resource = [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*"
        ]
      }
    ]
  })
}

# Read SecureString secrets at cold start (the function resolves COOKIE_SECRET /
# RESEND_API_KEY from SSM by name so they never live in the function config).
resource "aws_iam_role_policy" "ssm" {
  count = length(var.ssm_parameter_arns) > 0 ? 1 : 0

  name = "${var.name}-lambda-ssm"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameters"]
        Resource = var.ssm_parameter_arns
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "ssm.${var.region}.amazonaws.com"
          }
        }
      }
    ]
  })
}
