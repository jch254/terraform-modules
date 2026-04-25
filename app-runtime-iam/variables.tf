variable "name" {
  description = "Name of the application. Used in ECS runtime IAM role and policy names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "region" {
  description = "AWS region used for the SSM KMS ViaService condition."
  type        = string
}

variable "ssm_parameter_arns" {
  description = "SSM parameter ARNs the ECS execution role may read for container secrets."
  type        = list(string)
}

variable "dynamodb_table_arn" {
  description = "DynamoDB table ARN the ECS task role may access."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to IAM roles."
  type        = map(string)
  default     = {}
}