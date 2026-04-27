variable "name" {
  description = "Resource name prefix. Resources are suffixed (e.g. `<name>-build-notifications`, `<name>-build-notification-formatter`)."
  type        = string
}

variable "environment" {
  description = "Environment tag value applied to created resources."
  type        = string
}

variable "notification_email" {
  description = "Email address subscribed to the SNS topic."
  type        = string
}

variable "codebuild_project_names" {
  description = "CodeBuild project names whose SUCCEEDED/FAILED state changes trigger notifications."
  type        = list(string)
}

variable "app_url" {
  description = "Public application URL included in the notification body (passed to the formatter as APP_URL)."
  type        = string
  default     = ""
}

variable "github_repo_url" {
  description = "GitHub repository URL used to render commit links (passed to the formatter as GITHUB_REPO_URL). Trailing `.git` is stripped by the caller if present."
  type        = string
  default     = ""
}

variable "lambda_runtime" {
  description = "Lambda runtime for the formatter."
  type        = string
  default     = "nodejs20.x"
}
