output "vpc_link_security_group_id" {
  description = "ID of the API Gateway VPC Link security group."
  value       = aws_security_group.vpc_link.id
}

output "vpc_link_security_group_name" {
  description = "Name of the API Gateway VPC Link security group."
  value       = aws_security_group.vpc_link.name
}

output "vpc_link_security_group_arn" {
  description = "ARN of the API Gateway VPC Link security group."
  value       = aws_security_group.vpc_link.arn
}

output "ecs_security_group_id" {
  description = "ID of the ECS task security group."
  value       = aws_security_group.ecs.id
}

output "ecs_security_group_name" {
  description = "Name of the ECS task security group."
  value       = aws_security_group.ecs.name
}

output "ecs_security_group_arn" {
  description = "ARN of the ECS task security group."
  value       = aws_security_group.ecs.arn
}