variable "name" {
  description = "Name of Lambda function"
}

variable "artifact_path" {
  description = "Path to the Lambda function's artifact. Cannot be used with artifacts_dir variable."
  default     = ""
}

variable "artifact_base64sha256" {
  description = "Base64-encoded representation of raw SHA-256 sum of the Lambda function's artifact. Cannot be used with artifacts_dir variable."
  default     = ""
}

variable "artifacts_dir" {
  description = "Path to folder containing Lambda function's artifacts. Directory contents will be zipped. Cannot be used with artifact_path and artifact_base64sha256 variables."
  default     = ""
}

variable "deployment_s3_bucket" {
  description = "The S3 bucket where the Lambda function will be deployed. If not provided an S3 bucket will be created."
  default     = ""
}

variable "log_retention" {
  description = "Specifies the number of days to retain log events"
  default     = 7
}

variable "runtime" {
  description = "Runtime environment for the Lambda function. See: https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime."
}

variable "role_arn" {
  description = "IAM role attached to the Lambda Function"
}

variable "handler" {
  description = "The function that Lambda calls to begin execution"
}

variable "description" {
  description = "Description of what the Lambda Function does"
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB the Lambda Function can use at runtime"
  default     = 128
}

variable "timeout" {
  description = "Amount of time in seconds the Lambda Function has to run"
  default     = 60
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda function. E.g. { NAME = \"VALUE\"}"
  type        = map(string)
  default     = {}
}

variable "schedule_expression" {
  description = "A valid rate or cron expression - see: http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html"
  default     = ""
}
