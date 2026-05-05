output "vpc_link_security_group_id" {
  description = "ID of the API Gateway VPC Link security group."
  value       = module.app_security_groups.vpc_link_security_group_id
}

output "vpc_link_security_group_name" {
  description = "Name of the API Gateway VPC Link security group."
  value       = module.app_security_groups.vpc_link_security_group_name
}

output "vpc_link_security_group_arn" {
  description = "ARN of the API Gateway VPC Link security group."
  value       = module.app_security_groups.vpc_link_security_group_arn
}

output "ecs_security_group_id" {
  description = "ID of the ECS task security group."
  value       = module.app_security_groups.ecs_security_group_id
}

output "ecs_security_group_name" {
  description = "Name of the ECS task security group."
  value       = module.app_security_groups.ecs_security_group_name
}

output "ecs_security_group_arn" {
  description = "ARN of the ECS task security group."
  value       = module.app_security_groups.ecs_security_group_arn
}

output "cloudmap_namespace_id" {
  description = "ID of the Cloud Map private DNS namespace."
  value       = module.cloudmap_private_service.namespace_id
}

output "cloudmap_namespace_name" {
  description = "Name of the Cloud Map private DNS namespace."
  value       = module.cloudmap_private_service.namespace_name
}

output "cloudmap_namespace_arn" {
  description = "ARN of the Cloud Map private DNS namespace."
  value       = module.cloudmap_private_service.namespace_arn
}

output "cloudmap_service_id" {
  description = "ID of the Cloud Map service."
  value       = module.cloudmap_private_service.service_id
}

output "cloudmap_service_name" {
  description = "Name of the Cloud Map service."
  value       = module.cloudmap_private_service.service_name
}

output "cloudmap_service_arn" {
  description = "ARN of the Cloud Map service."
  value       = module.cloudmap_private_service.service_arn
}

output "api_id" {
  description = "ID of the HTTP API."
  value       = module.http_api_cloudmap_proxy.api_id
}

output "api_arn" {
  description = "ARN of the HTTP API."
  value       = module.http_api_cloudmap_proxy.api_arn
}

output "api_endpoint" {
  description = "Default endpoint of the HTTP API."
  value       = module.http_api_cloudmap_proxy.api_endpoint
}

output "vpc_link_id" {
  description = "ID of the API Gateway VPC Link."
  value       = module.http_api_cloudmap_proxy.vpc_link_id
}

output "integration_id" {
  description = "ID of the API Gateway integration."
  value       = module.http_api_cloudmap_proxy.integration_id
}

output "route_id" {
  description = "ID of the API Gateway route."
  value       = module.http_api_cloudmap_proxy.route_id
}

output "stage_id" {
  description = "ID of the API Gateway stage."
  value       = module.http_api_cloudmap_proxy.stage_id
}

output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs_fargate_service.cluster_name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = module.ecs_fargate_service.cluster_arn
}

output "cluster_id" {
  description = "ID of the ECS cluster."
  value       = module.ecs_fargate_service.cluster_id
}

output "service_name" {
  description = "Name of the ECS service."
  value       = module.ecs_fargate_service.service_name
}

output "service_id" {
  description = "ID of the ECS service."
  value       = module.ecs_fargate_service.service_id
}

output "service_arn" {
  description = "ARN of the ECS service."
  value       = module.ecs_fargate_service.service_arn
}

output "task_definition_arn" {
  description = "ARN of the active ECS task definition revision."
  value       = module.ecs_fargate_service.task_definition_arn
}

output "log_group_name" {
  description = "Name of the CloudWatch log group used by the ECS task."
  value       = module.ecs_fargate_service.log_group_name
}

output "log_group_arn" {
  description = "ARN of the managed CloudWatch log group when create_log_group is true."
  value       = module.ecs_fargate_service.log_group_arn
}
