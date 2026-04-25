locals {
  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}

resource "aws_dynamodb_table" "main" {
  name         = var.name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = try(global_secondary_index.value.range_key, null)
      projection_type    = try(global_secondary_index.value.projection_type, "ALL")
      non_key_attributes = try(global_secondary_index.value.non_key_attributes, null)
    }
  }

  ttl {
    attribute_name = var.ttl_attribute_name
    enabled        = var.ttl_enabled
  }

  tags = local.tags
}