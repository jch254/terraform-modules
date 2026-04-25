locals {
  default_webhook_filter_groups = [[
    {
      type    = "EVENT"
      pattern = "PUSH"
    },
    {
      type    = "HEAD_REF"
      pattern = "refs/heads/main"
    },
  ]]

  webhook_filter_groups = length(var.webhook_filter_groups) > 0 ? var.webhook_filter_groups : local.default_webhook_filter_groups
}

resource "aws_cloudwatch_log_group" "codebuild_lg" {
  name              = "/aws/codebuild/${var.name}"
  retention_in_days = var.log_retention
  tags              = var.tags
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = var.name
  description   = var.description != "" ? var.description : "Builds, tests and deploys ${var.name}"
  service_role  = var.codebuild_role_arn
  badge_enabled = var.badge_enabled

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = "${var.build_docker_image}:${var.build_docker_tag}"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = var.image_pull_credentials_type != "" ? var.image_pull_credentials_type : null
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables

      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = lookup(environment_variable.value, "type", "PLAINTEXT")
      }
    }
  }

  source {
    type            = var.source_type
    buildspec       = var.buildspec
    location        = var.source_location
    git_clone_depth = var.git_clone_depth
  }

  cache {
    type     = var.cache_bucket == "" ? "NO_CACHE" : "S3"
    location = var.cache_bucket
  }

  tags = var.tags
}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  count = var.webhook_enabled ? 1 : 0

  project_name = aws_codebuild_project.codebuild_project.name
  build_type   = var.webhook_build_type

  dynamic "filter_group" {
    for_each = local.webhook_filter_groups

    content {
      dynamic "filter" {
        for_each = filter_group.value

        content {
          type                    = filter.value.type
          pattern                 = filter.value.pattern
          exclude_matched_pattern = lookup(filter.value, "exclude_matched_pattern", null)
        }
      }
    }
  }
}
