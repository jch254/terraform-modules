output "namespace_id" {
  description = "ID of the Cloud Map private DNS namespace."
  value       = aws_service_discovery_private_dns_namespace.main.id
}

output "namespace_name" {
  description = "Name of the Cloud Map private DNS namespace."
  value       = aws_service_discovery_private_dns_namespace.main.name
}

output "namespace_arn" {
  description = "ARN of the Cloud Map private DNS namespace."
  value       = aws_service_discovery_private_dns_namespace.main.arn
}

output "service_id" {
  description = "ID of the Cloud Map service."
  value       = aws_service_discovery_service.main.id
}

output "service_name" {
  description = "Name of the Cloud Map service."
  value       = aws_service_discovery_service.main.name
}

output "service_arn" {
  description = "ARN of the Cloud Map service."
  value       = aws_service_discovery_service.main.arn
}