output "execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = aws_iam_role.ecs_execution_role.arn
}

output "execution_role_name" {
  description = "Name of the ECS task execution role."
  value       = aws_iam_role.ecs_execution_role.name
}

output "task_role_arn" {
  description = "ARN of the ECS task role."
  value       = aws_iam_role.ecs_task_role.arn
}

output "task_role_name" {
  description = "Name of the ECS task role."
  value       = aws_iam_role.ecs_task_role.name
}