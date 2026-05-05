locals {
  tags = merge(
    {
      Environment = var.environment
    },
    var.tags,
  )
}

module "app_security_groups" {
  source = "../app-security-groups"

  name           = var.name
  environment    = var.environment
  vpc_id         = var.vpc_id
  container_port = var.container_port
  tags           = local.tags
}

module "cloudmap_private_service" {
  source = "../cloudmap-private-service"

  name              = var.name
  environment       = var.environment
  vpc_id            = var.vpc_id
  namespace_name    = var.cloudmap_namespace_name
  service_name      = var.cloudmap_service_name
  dns_record_type   = var.cloudmap_dns_record_type
  dns_record_ttl    = var.cloudmap_dns_record_ttl
  routing_policy    = var.cloudmap_routing_policy
  failure_threshold = var.cloudmap_failure_threshold
  tags              = local.tags
}

module "http_api_cloudmap_proxy" {
  source = "../http-api-cloudmap-proxy"

  name                        = var.name
  environment                 = var.environment
  subnet_ids                  = var.subnet_ids
  vpc_link_security_group_ids = [module.app_security_groups.vpc_link_security_group_id]
  cloudmap_service_arn        = module.cloudmap_private_service.service_arn
  route_key                   = var.route_key
  stage_name                  = var.stage_name
  auto_deploy                 = var.auto_deploy
  integration_method          = var.integration_method
  tags                        = local.tags
}

module "ecs_fargate_service" {
  source = "../ecs-fargate-service"

  name               = var.name
  environment        = var.environment
  cluster_name       = var.cluster_name
  service_name       = var.ecs_service_name
  task_family        = var.task_family
  container_name     = var.container_name
  image              = var.image
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_port        = var.container_port
  host_port             = var.host_port
  log_group_name        = var.log_group_name
  create_log_group      = var.create_log_group
  log_retention_in_days = var.log_retention_in_days
  log_group_tags        = var.log_group_tags
  log_region            = var.log_region
  log_stream_prefix     = var.log_stream_prefix

  environment_variables = var.environment_variables
  secrets               = var.secrets
  health_check          = var.health_check
  essential             = var.essential

  subnet_ids           = var.subnet_ids
  security_group_id    = module.app_security_groups.ecs_security_group_id
  assign_public_ip     = var.assign_public_ip
  cloudmap_service_arn = module.cloudmap_private_service.service_arn

  desired_count                       = var.desired_count
  deployment_minimum_healthy_percent  = var.deployment_minimum_healthy_percent
  deployment_maximum_percent          = var.deployment_maximum_percent
  health_check_grace_period_seconds   = var.health_check_grace_period_seconds
  deployment_circuit_breaker_enable   = var.deployment_circuit_breaker_enable
  deployment_circuit_breaker_rollback = var.deployment_circuit_breaker_rollback
  container_insights                  = var.container_insights
  operating_system_family             = var.operating_system_family
  cpu_architecture                    = var.cpu_architecture
  tags                                = local.tags
}
