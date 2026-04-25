locals {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  execution_role_tags = merge(
    {
      Name        = "${var.name}-ecs-execution-role"
      Environment = var.environment
    },
    var.tags,
  )

  task_role_tags = merge(
    {
      Name        = "${var.name}-ecs-task-role"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.name}-ecs-execution-role"
  assume_role_policy = local.assume_role_policy

  tags = local.execution_role_tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_execution_ssm" {
  name = "${var.name}-ecs-execution-ssm"
  role = aws_iam_role.ecs_execution_role.id

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

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.name}-ecs-task-role"
  assume_role_policy = local.assume_role_policy

  tags = local.task_role_tags
}

resource "aws_iam_role_policy" "ecs_task_dynamodb" {
  name = "${var.name}-ecs-task-dynamodb"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:DescribeTable"
        ]
        Resource = [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*"
        ]
      }
    ]
  })
}