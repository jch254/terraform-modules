variable "name" {
  description = "Name of project (used in AWS resource names)"
}

variable "log_retention" {
  description = "Specifies the number of days to retain build log events"
  default     = 7
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

variable "source_type" {
  description = "Type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB or S3."
}

variable "buildspec" {
  description = "The CodeBuild build spec declaration path - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html"
}

variable "source_location" {
  description = "HTTPS URL of CodeCommit repo or S3 bucket to use as project source"
}

variable "cache_bucket" {
  description = "S3 bucket to use as build cache, the value must be a valid S3 bucket name/prefix"
  default     = ""
}
