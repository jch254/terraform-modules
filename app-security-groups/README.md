# app-security-groups

Manages the security groups for an API Gateway VPC Link and ECS tasks.

The module intentionally preserves inline security group rules. Do not split these into standalone `aws_security_group_rule` resources during the reference-architecture migration.

## Example

```hcl
module "app_security_groups" {
  source = "git::https://github.com/jch254/terraform-modules.git//app-security-groups?ref=<version>"

  name           = var.name
  environment    = var.environment
  vpc_id         = data.aws_vpc.existing.id
  container_port = 3000

  tags = {
    Environment = var.environment
  }
}
```

Defaults match the current reference-architecture port `3000` path: the VPC Link security group has all egress, and the ECS security group allows inbound TCP traffic from the VPC Link security group on `container_port` plus all egress.

## Migration Notes

Security group replacement is not acceptable for long-lived infrastructure. Move state into this module and require a no-op remote-state plan before moving on.

Expected move targets:

```hcl
moved { from = aws_security_group.vpc_link to = module.app_security_groups.aws_security_group.vpc_link }
moved { from = aws_security_group.ecs to = module.app_security_groups.aws_security_group.ecs }
```