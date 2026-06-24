variable "name" {
  description = "Name of the application. Used in the Lambda runtime IAM role and policy names."
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
  description = "SSM parameter ARNs the Lambda may read for runtime secrets. Empty disables the SSM policy."
  type        = list(string)
  default     = []
}

variable "dynamodb_table_arn" {
  description = "DynamoDB table ARN the Lambda may access."
  type        = string
}

variable "dynamodb_actions" {
  description = "DynamoDB actions granted to the Lambda for the app table and indexes."
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
  description = "Additional tags to apply to the IAM role."
  type        = map(string)
  default     = {}
}
