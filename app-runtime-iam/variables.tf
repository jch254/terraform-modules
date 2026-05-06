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

variable "dynamodb_actions" {
  description = "DynamoDB actions granted to the ECS task role for the app table and indexes."
  type        = list(string)
  default = [
    "dynamodb:GetItem",
    "dynamodb:PutItem",
    "dynamodb:UpdateItem",
    "dynamodb:DeleteItem",
    "dynamodb:BatchWriteItem",
    "dynamodb:Query",
    "dynamodb:DescribeTable",
  ]
}

variable "tags" {
  description = "Additional tags to apply to IAM roles."
  type        = map(string)
  default     = {}
}
