variable "name" {
  description = "Name of project (used in AWS resource names)"
}

variable "log_retention" {
  description = "Specifies the number of days to retain build log events"
  default = 90
}

variable "codebuild_role_arn" {
  description = "ARN of IAM role that allows CodeBuild to interact with dependent AWS services"
}

variable "build_compute_type" {
  description = "CodeBuild compute type (e.g. BUILD_GENERAL1_SMALL)"
  default = "BUILD_GENERAL1_SMALL"
}

variable "build_docker_image" {
  description = "Docker image to use as build environment"
}

variable "build_docker_tag" {
  description = "Docker image tag to use as build environment"
}

variable "privileged_mode" {
  description = "If set to true, enables running the Docker daemon inside a Docker container"
  default = "false"
}

variable "buildspec" {
  description = "The CodeBuild build spec declaration expressed as a single string - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html"
}

variable "artifact_store_s3_bucket" {
  description = "S3 bucket where CodePipeline stores source artifacts, if not provided an S3 bucket will be created"
  default = ""
}

variable "require_approval" {
  description = "Does the pipeline require approval to run?"
  default = "false"
}

variable "codepipeline_role_arn" {
  description = "ARN of IAM role that allows CodePipeline to interact with dependent AWS services"
}

variable "github_oauth_token" {
  description = "OAuth token used to authenticate against CodePipeline source GitHub repository"
}

variable "github_repository_owner" {
  description = "Owner of GitHub repository to use as CodePipeline source"
}

variable "github_repository_name" {
  description = "Name of GitHub repository to use as CodePipeline source"
}

variable "github_branch_name" {
  description = "GitHub repository branch to use as CodePipeline source"
}

variable "approval_sns_topic_arn" {
  description = "Approval notifications will be published to the specified SNS topic. Required if require_approval is true."
  default = ""
}

variable "approval_comment" {
  description = "Comment to include in approval notifications. Required if require_approval is true."
  default = "A production deploy has been requested."
}
