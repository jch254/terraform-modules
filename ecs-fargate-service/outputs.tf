output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.main.arn
}

output "cluster_id" {
  description = "ID of the ECS cluster."
  value       = aws_ecs_cluster.main.id
}

output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.main.name
}

output "service_id" {
  description = "ID of the ECS service."
  value       = aws_ecs_service.main.id
}

output "service_arn" {
  description = "ARN of the ECS service."
  value       = aws_ecs_service.main.id
}

output "task_definition_arn" {
  description = "ARN of the active ECS task definition revision managed by this module."
  value       = aws_ecs_task_definition.main.arn
}

output "task_definition_family" {
  description = "Family of the ECS task definition."
  value       = aws_ecs_task_definition.main.family
}

output "log_group_name" {
  description = "Name of the CloudWatch log group used by the ECS task."
  value       = local.log_group_name
}

output "log_group_arn" {
  description = "ARN of the managed CloudWatch log group when create_log_group is true."
  value       = var.create_log_group ? aws_cloudwatch_log_group.main[0].arn : null
}
