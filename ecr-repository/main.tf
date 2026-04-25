locals {
  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}

resource "aws_ecr_repository" "main" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = local.tags
}

resource "aws_ecr_lifecycle_policy" "main" {
  count = var.lifecycle_policy_json == null ? 0 : 1

  repository = aws_ecr_repository.main.name
  policy     = var.lifecycle_policy_json
}