variable "name" {
  description = "Resource name prefix for the app-owned EventBridge rule and target."
  type        = string
}

variable "environment" {
  description = "Environment tag value applied to created resources."
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the shared build notification formatter Lambda."
  type        = string
}

variable "codebuild_project_names" {
  description = "CodeBuild project names whose SUCCEEDED/FAILED state changes trigger notifications."
  type        = list(string)
}

variable "app_url" {
  description = "Public application URL included in the notification body."
  type        = string
  default     = ""
}

variable "github_repo_url" {
  description = "GitHub repository URL used to render commit links. A trailing `.git` is stripped."
  type        = string
  default     = ""
}
