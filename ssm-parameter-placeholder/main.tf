locals {
  default_name_tag = replace(trimprefix(var.name, "/"), "/", "-")

  tags = merge(
    {
      Name = local.default_name_tag
    },
    var.tags,
  )
}

resource "aws_ssm_parameter" "main" {
  name        = var.name
  description = var.description
  type        = var.type
  value       = var.placeholder_value
  tier        = var.tier
  key_id      = var.key_id

  lifecycle {
    ignore_changes = [value]
  }

  tags = local.tags
}
