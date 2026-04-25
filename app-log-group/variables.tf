variable "name" {
  description = "Name of the application. Used to derive the default ECS log group name."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "log_group_name" {
  description = "CloudWatch log group name. Defaults to /ecs/<name>."
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "Number of days to retain application logs."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Additional tags to apply to the log group."
  type        = map(string)
  default     = {}
}