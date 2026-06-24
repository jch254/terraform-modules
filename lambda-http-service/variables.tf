variable "name" {
  description = "Name of the application. Used for the Lambda function, log group, and API Gateway names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "image" {
  description = "Full ECR image URI (including tag) for the container-image Lambda. The image must already exist in ECR before the function is created."
  type        = string
}

variable "role_arn" {
  description = "ARN of the Lambda execution role (trusts lambda.amazonaws.com; needs logs, plus app DynamoDB/SSM access)."
  type        = string
}

variable "description" {
  description = "Description of the Lambda function."
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB the Lambda function can use at runtime."
  type        = number
  default     = 512
}

variable "timeout" {
  description = "Amount of time in seconds the Lambda function has to run."
  type        = number
  default     = 30
}

variable "architecture" {
  description = "Instruction set architecture for the Lambda function: x86_64 or arm64. Must match the container image."
  type        = string
  default     = "x86_64"

  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "architecture must be either x86_64 or arm64."
  }
}

variable "log_retention_in_days" {
  description = "Number of days to retain the Lambda CloudWatch log group."
  type        = number
  default     = 7
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function. E.g. { NAME = \"VALUE\" }."
  type        = map(string)
  default     = {}
}

variable "route_key" {
  description = "HTTP API route key. Defaults to the catch-all so the Lambda serves every method and path."
  type        = string
  default     = "$default"
}

variable "stage_name" {
  description = "HTTP API stage name. Defaults to $default so the API serves at the domain root with no stage prefix."
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Whether API Gateway automatically deploys changes to the stage."
  type        = bool
  default     = true
}

variable "payload_format_version" {
  description = "API Gateway HTTP API Lambda-proxy payload format version."
  type        = string
  default     = "2.0"
}

variable "access_log_destination_arn" {
  description = "Optional CloudWatch log group ARN for HTTP API stage access logs."
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "Optional HTTP API stage access log format. Used only when access_log_destination_arn is set."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the Lambda and API Gateway resources."
  type        = map(string)
  default     = {}
}
