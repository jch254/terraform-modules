locals {
  log_group_name = coalesce(var.log_group_name, "/ecs/${var.name}")

  tags = merge(
    {
      Name        = "${var.name}-logs"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_cloudwatch_log_group" "main" {
  name              = local.log_group_name
  retention_in_days = var.retention_in_days

  tags = local.tags
}