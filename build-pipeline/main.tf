resource "aws_cloudwatch_log_group" "codebuild_lg" {
  name              = "/aws/codebuild/${var.name}"
  retention_in_days = var.log_retention
}

resource "aws_codebuild_project" "codebuild_project" {
  name         = var.name
  description  = "Builds, tests and deploys ${var.name}"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = "${var.build_docker_image}:${var.build_docker_tag}"
    type            = "LINUX_CONTAINER"
    privileged_mode = var.privileged_mode
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }

  cache {
    type     = var.cache_bucket == "" ? "NO_CACHE" : "S3"
    location = var.cache_bucket
  }
}

resource "aws_s3_bucket" "artifacts" {
  count = var.artifact_store_s3_bucket == "" ? 1 : 0

  bucket        = "${var.name}-artifacts"
  acl           = "private"
  force_destroy = true
}

resource "aws_codepipeline" "codepipeline" {
  count = var.require_approval == "false" ? 1 : 0

  name     = var.name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.artifact_store_s3_bucket !== "" var.artifact_store_s3_bucket : aws_s3_bucket.artifacts[0].id
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "pull-source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        OAuthToken = var.github_oauth_token
        Owner      = var.github_repository_owner
        Repo       = var.github_repository_name
        Branch     = var.github_branch_name
      }
    }
  }

  stage {
    name = "CodeBuild"

    action {
      name            = "execute-codebuild"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }
}

resource "aws_codepipeline" "codepipeline_with_approval" {
  count = var.require_approval == "true" ? 1 : 0

  name     = var.name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.artifact_store_s3_bucket !== "" var.artifact_store_s3_bucket : aws_s3_bucket.artifacts[0].id
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "pull-source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        OAuthToken = var.github_oauth_token
        Owner      = var.github_repository_owner
        Repo       = var.github_repository_name
        Branch     = var.github_branch_name
      }
    }
  }

  stage {
    name = "Approval"

    action {
      name     = "manual-approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn = var.approval_sns_topic_arn
        CustomData      = var.approval_comment
      }
    }
  }

  stage {
    name = "CodeBuild"

    action {
      name            = "execute-codebuild"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_project.name
      }
    }
  }
}
