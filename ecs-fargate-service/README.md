# ecs-fargate-service

Manages an ECS Fargate cluster, task definition, and service.

This module accepts IAM roles, security groups, subnets, Cloud Map service, log group, image, environment variables, and secrets as inputs so application-specific values remain in the consuming stack.

## Example

```hcl
module "ecs_fargate_service" {
  source = "git::https://github.com/jch254/terraform-modules.git//ecs-fargate-service?ref=<version>"

  name        = var.name
  environment = var.environment

  image              = "${module.ecr_repository.repository_url}:${var.image_tag}"
  cpu                = var.container_cpu
  memory             = var.container_memory
  execution_role_arn = module.app_runtime_iam.execution_role_arn
  task_role_arn      = module.app_runtime_iam.task_role_arn

  log_group_name = module.app_log_group.name
  log_region     = var.region

  subnet_ids         = data.aws_subnets.public.ids
  security_group_id  = module.app_security_groups.ecs_security_group_id
  cloudmap_service_arn = module.cloudmap_private_service.service_arn

  environment_variables = [
    { name = "PORT", value = "3000" },
    { name = "DYNAMODB_TABLE", value = module.dynamodb_single_table.table_name },
    { name = "AWS_REGION", value = var.region },
  ]

  secrets = [
    { name = "COOKIE_SECRET", valueFrom = aws_ssm_parameter.cookie_secret.arn },
  ]

  tags = {
    Environment = var.environment
  }

  depends_on = [module.app_runtime_iam]
}
```

Defaults preserve the current reference-architecture deployment posture: Fargate, `awsvpc`, public subnet support with `assign_public_ip = true`, desired count `1`, deployment minimum healthy percent `100`, maximum percent `200`, health check grace period `60`, deployment circuit breaker enabled with rollback, disabled container insights, Linux/X86_64 runtime, container port `3000`, and the existing health check command.

## Migration Notes

Move the ECS cluster, task definition, and service into this module before applying. ECS service replacement is not acceptable. A task definition revision can be acceptable only when the consumer migration explicitly justifies it, typically due to normalized container definition JSON, image tag changes, or intentional app configuration changes.

Expected move targets:

```hcl
moved { from = aws_ecs_cluster.main to = module.ecs_fargate_service.aws_ecs_cluster.main }
moved { from = aws_ecs_task_definition.main to = module.ecs_fargate_service.aws_ecs_task_definition.main }
moved { from = aws_ecs_service.main to = module.ecs_fargate_service.aws_ecs_service.main }
```

During consumer migration, confirm subnet ordering, security group ID, service registry ARN, task family, service name, and deployment settings all remain unchanged.