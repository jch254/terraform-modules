locals {
  vpc_link_tags = merge(
    {
      Name        = "${var.name}-vpc-link-sg"
      Environment = var.environment
    },
    var.tags,
  )

  ecs_tags = merge(
    {
      Name        = "${var.name}-ecs-sg"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_security_group" "vpc_link" {
  name        = "${var.name}-vpc-link-sg"
  description = "Security group for API Gateway VPC Link"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.vpc_link_tags
}

resource "aws_security_group" "ecs" {
  name        = "${var.name}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc_link.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.ecs_tags
}