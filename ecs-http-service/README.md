# ecs-http-service

Composite module for the standard low-cost ECS HTTP runtime:

- API Gateway VPC Link and ECS task security groups
- Cloud Map private namespace and service
- API Gateway HTTP API, VPC Link, Cloud Map integration, default route, and stage
- ECS Fargate cluster, task definition, service, and optional log group

Use this for new apps that follow the reference architecture runtime shape. Keep using the primitive modules directly when an app needs bespoke networking, multiple services, or migration-specific state handling.

Custom domains, ACM certificates, DNS records, ECR repositories, DynamoDB tables, runtime IAM roles, CodeBuild projects, and app-specific secrets remain outside this module.

## Example

```hcl
module "ecs_http_service" {
  source = "github.com/jch254/terraform-modules//ecs-http-service?ref=1.9.0"

  name        = var.name
  environment = var.environment
  vpc_id      = data.aws_vpc.existing.id
  subnet_ids  = data.aws_subnets.public.ids

  image              = "${module.ecr_repository.repository_url}:${var.image_tag}"
  cpu                = var.container_cpu
  memory             = var.container_memory
  execution_role_arn = module.app_runtime_iam.execution_role_arn
  task_role_arn      = module.app_runtime_iam.task_role_arn

  log_region = var.region

  environment_variables = [
    { name = "PORT", value = "3000" },
    { name = "AWS_REGION", value = var.region },
  ]

  tags = {
    Environment = var.environment
  }
}
```

## Migration Notes

For an existing app already using the primitive modules, add `moved` blocks from each primitive module address into this composite module. For example:

```hcl
moved { from = module.app_security_groups.aws_security_group.vpc_link to = module.ecs_http_service.module.app_security_groups.aws_security_group.vpc_link }
moved { from = module.cloudmap_private_service.aws_service_discovery_service.main to = module.ecs_http_service.module.cloudmap_private_service.aws_service_discovery_service.main }
moved { from = module.http_api_cloudmap_proxy.aws_apigatewayv2_api.main to = module.ecs_http_service.module.http_api_cloudmap_proxy.aws_apigatewayv2_api.main }
moved { from = module.ecs_fargate_service.aws_ecs_service.main to = module.ecs_http_service.module.ecs_fargate_service.aws_ecs_service.main }
```

If the log group was previously managed by `app-log-group`, move it to `module.ecs_http_service.module.ecs_fargate_service.aws_cloudwatch_log_group.main[0]` and set `create_log_group = true`.
