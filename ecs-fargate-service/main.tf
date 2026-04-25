locals {
  cluster_name   = coalesce(var.cluster_name, "${var.name}-cluster")
  service_name   = coalesce(var.service_name, "${var.name}-service")
  task_family    = coalesce(var.task_family, var.name)
  container_name = coalesce(var.container_name, var.name)
  host_port      = coalesce(var.host_port, var.container_port)

  cluster_tags = merge(
    {
      Name        = "${var.name}-cluster"
      Environment = var.environment
    },
    var.tags,
  )

  task_definition_tags = merge(
    {
      Name        = var.name
      Environment = var.environment
    },
    var.tags,
  )

  service_tags = merge(
    {
      Name        = "${var.name}-service"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  tags = local.cluster_tags
}

resource "aws_ecs_task_definition" "main" {
  family                   = local.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([
    {
      name  = local.container_name
      image = var.image

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = local.host_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.log_region
          "awslogs-stream-prefix" = var.log_stream_prefix
        }
      }

      environment = var.environment_variables
      secrets     = var.secrets
      healthCheck = var.health_check
      essential   = var.essential
    }
  ])

  tags = local.task_definition_tags
}

resource "aws_ecs_service" "main" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker_enable
    rollback = var.deployment_circuit_breaker_rollback
  }

  network_configuration {
    security_groups  = [var.security_group_id]
    subnets          = var.subnet_ids
    assign_public_ip = var.assign_public_ip
  }

  service_registries {
    registry_arn = var.cloudmap_service_arn
    port         = var.container_port
  }

  tags = local.service_tags
}