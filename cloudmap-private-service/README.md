# cloudmap-private-service

Manages a Cloud Map private DNS namespace and service for ECS service discovery.

## Example

```hcl
module "cloudmap_private_service" {
  source = "git::https://github.com/jch254/terraform-modules.git//cloudmap-private-service?ref=<version>"

  name        = var.name
  environment = var.environment
  vpc_id      = data.aws_vpc.existing.id

  tags = {
    Environment = var.environment
  }
}
```

Defaults match the current reference-architecture runtime edge: namespace `${name}.local`, service `${name}-service`, `SRV` record, TTL `1`, `MULTIVALUE` routing, and custom health failure threshold `1`.

## Migration Notes

Cloud Map namespace and service replacement is not acceptable. Keep namespace and service together in this phase, move state into this module, and stop if Terraform plans to replace either resource.

Expected move targets:

```hcl
moved { from = aws_service_discovery_private_dns_namespace.main to = module.cloudmap_private_service.aws_service_discovery_private_dns_namespace.main }
moved { from = aws_service_discovery_service.main to = module.cloudmap_private_service.aws_service_discovery_service.main }
```