variable "name" {
  description = "Name of project (used in AWS resource names)"
}

variable "description" {
  description = "Description for the CodeBuild project. Defaults to the legacy module description when empty."
  default     = ""
}

variable "log_retention" {
  description = "Specifies the number of days to retain build log events"
  default     = 7
}

variable "create_log_group" {
  description = "Whether to create and manage the default /aws/codebuild/<name> CloudWatch log group. Set false when the log group is managed outside this module or when preserving parity with an existing unmanaged/default CodeBuild logging setup."
  type        = bool
  default     = true
}

variable "codebuild_role_arn" {
  description = "ARN of IAM role that allows CodeBuild to interact with dependent AWS services"
}

variable "build_compute_type" {
  description = "CodeBuild compute type (e.g. BUILD_GENERAL1_SMALL)"
  default     = "BUILD_GENERAL1_SMALL"
}

variable "build_docker_image" {
  description = "Docker image to use as build environment"
}

variable "build_docker_tag" {
  description = "Docker image tag to use as build environment"
}

variable "privileged_mode" {
  description = "If set to true, enables running the Docker daemon inside a Docker container"
  default     = "false"
}

variable "image_pull_credentials_type" {
  description = "Type of credentials CodeBuild uses to pull the build image. Leave empty to use the AWS provider default."
  default     = ""
}

variable "environment_variables" {
  description = "Environment variables for the build environment. Each item supports name, value, and optional type."
  type        = list(map(string))
  default     = []
}

variable "source_type" {
  description = "Type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB or S3."
}

variable "buildspec" {
  description = "The CodeBuild build spec declaration path - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html"
}

variable "source_location" {
  description = "HTTPS URL of CodeCommit repo or S3 bucket to use as project source"
}

variable "git_clone_depth" {
  description = "Optional git clone depth for source checkout."
  default     = null
}

variable "cache_bucket" {
  description = "S3 bucket to use as build cache, the value must be a valid S3 bucket name/prefix"
  default     = ""
}

variable "badge_enabled" {
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url output when true."
  default     = true
}

variable "tags" {
  description = "Tags to apply to CodeBuild resources."
  type        = map(string)
  default     = {}
}

variable "webhook_enabled" {
  description = "Whether to create a CodeBuild webhook for the project."
  default     = false
}

variable "webhook_build_type" {
  description = "Webhook build type."
  default     = "BUILD"
}

variable "webhook_filter_groups" {
  description = "Webhook filter groups. Defaults to push events on refs/heads/main when webhook_enabled is true and no filters are provided."
  type        = list(list(map(string)))
  default     = []
}
