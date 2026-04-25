# app-log-group

Manages the CloudWatch log group used by an ECS application task.

## Example

```hcl
module "app_log_group" {
  source = "git::https://github.com/jch254/terraform-modules.git//app-log-group?ref=<version>"

  name        = var.name
  environment = var.environment

  tags = {
    Environment = var.environment
  }
}
```

The default `log_group_name` is `/ecs/${name}` and the default retention is `7` days, matching the current reference-architecture runtime log group shape.

## Migration Notes

When migrating an existing root-managed log group, move state into this module before applying the module-backed configuration. The reference-architecture migration should use a `moved` block or `terraform state mv` and then confirm remote-state plan parity before continuing.

Expected move target:

```hcl
moved {
  from = aws_cloudwatch_log_group.main
  to   = module.app_log_group.aws_cloudwatch_log_group.main
}
```