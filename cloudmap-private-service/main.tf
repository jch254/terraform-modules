locals {
  namespace_name = coalesce(var.namespace_name, "${var.name}.local")
  service_name   = coalesce(var.service_name, "${var.name}-service")

  namespace_tags = merge(
    {
      Name        = "${var.name}-namespace"
      Environment = var.environment
    },
    var.tags,
  )

  service_tags = merge(
    {
      Name        = "${var.name}-discovery-service"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_service_discovery_private_dns_namespace" "main" {
  name = local.namespace_name
  vpc  = var.vpc_id

  tags = local.namespace_tags
}

resource "aws_service_discovery_service" "main" {
  name         = local.service_name
  namespace_id = aws_service_discovery_private_dns_namespace.main.id

  dns_config {
    namespace_id   = aws_service_discovery_private_dns_namespace.main.id
    routing_policy = var.routing_policy

    dns_records {
      ttl  = var.dns_record_ttl
      type = var.dns_record_type
    }
  }

  health_check_custom_config {
    failure_threshold = var.failure_threshold
  }

  tags = local.service_tags
}