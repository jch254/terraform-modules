variable "name" {
  description = "Project or platform name prefix."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "role_name" {
  description = "IAM role name. Defaults to <name>-codebuild."
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Inline IAM policy name. Defaults to <name>-codebuild-policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the role."
  type        = map(string)
  default     = {}
}

variable "assume_role_services" {
  description = "AWS service principals that may assume the role."
  type        = list(string)
  default     = ["codebuild.amazonaws.com"]
}

variable "cloudwatch_logs_actions" {
  description = "CloudWatch Logs actions needed by the build and Terraform-managed log groups. Empty disables the statement."
  type        = list(string)
  default = [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "logs:DescribeLogGroups",
    "logs:DeleteLogGroup",
    "logs:PutRetentionPolicy",
    "logs:ListTagsForResource",
    "logs:TagResource",
    "logs:UntagResource",
  ]
}

variable "s3_read_write_resource_arns" {
  description = "S3 bucket/object ARNs that receive Terraform state style read/write/delete/list permissions."
  type        = list(string)
  default     = []
}

variable "s3_bucket_arns" {
  description = "S3 bucket ARNs that receive bucket-location and list permissions."
  type        = list(string)
  default     = []
}

variable "s3_object_arns" {
  description = "S3 object ARNs that receive object read/write/delete permissions."
  type        = list(string)
  default     = []
}

variable "ecr_repository_arns" {
  description = "ECR repository ARNs this role may push images to and manage."
  type        = list(string)
  default     = []
}

variable "enable_ecs" {
  description = "Whether to include ECS cluster/service/task-definition Terraform permissions."
  type        = bool
  default     = false
}

variable "enable_ec2_networking" {
  description = "Whether to include VPC/subnet/security-group read and security-group CRUD permissions."
  type        = bool
  default     = false
}

variable "enable_api_gateway" {
  description = "Whether to include API Gateway v2 Terraform permissions."
  type        = bool
  default     = false
}

variable "api_gateway_resource_arns" {
  description = "API Gateway resource ARNs used when enable_api_gateway is true."
  type        = list(string)
  default     = ["*"]
}

variable "enable_service_discovery" {
  description = "Whether to include Cloud Map namespace/service Terraform permissions."
  type        = bool
  default     = false
}

variable "enable_route53" {
  description = "Whether to include Route53 hosted-zone and record-set Terraform permissions."
  type        = bool
  default     = false
}

variable "enable_acm" {
  description = "Whether to include ACM certificate Terraform permissions (request, describe, delete, and tag mutations)."
  type        = bool
  default     = false
}

variable "acm_resource_arns" {
  description = "ACM resource ARNs used when enable_acm is true. Tagging APIs typically require '*'."
  type        = list(string)
  default     = ["*"]
}

variable "iam_role_arns" {
  description = "IAM role ARNs this build may manage or pass."
  type        = list(string)
  default     = []
}

variable "codebuild_project_arns" {
  description = "CodeBuild project ARNs this build may create, update, delete, and manage webhooks for."
  type        = list(string)
  default     = []
}

variable "ssm_parameter_arns" {
  description = "SSM parameter ARNs this build may manage."
  type        = list(string)
  default     = []
}

variable "secretsmanager_secret_arns" {
  description = "Secrets Manager secret ARNs this build may read."
  type        = list(string)
  default     = []
}

variable "dynamodb_table_arns" {
  description = "DynamoDB table ARNs this build may manage."
  type        = list(string)
  default     = []
}

variable "enable_ses" {
  description = "Whether to include SES identity and receipt-rule Terraform permissions."
  type        = bool
  default     = false
}

variable "ses_resource_arns" {
  description = "SES resource ARNs used when enable_ses is true. SES receipt APIs often require '*'."
  type        = list(string)
  default     = ["*"]
}

variable "sns_topic_arns" {
  description = "SNS topic ARNs this build may manage."
  type        = list(string)
  default     = []
}

variable "event_rule_arns" {
  description = "EventBridge rule ARNs this build may manage."
  type        = list(string)
  default     = []
}

variable "lambda_function_arns" {
  description = "Lambda function ARNs this build may create, update, delete, tag, and manage permissions for."
  type        = list(string)
  default     = []
}

variable "lambda_permission_function_arns" {
  description = "Lambda function ARNs where this build may only add/remove EventBridge invoke permissions and read policy."
  type        = list(string)
  default     = []
}

variable "additional_policy_statements" {
  description = "Additional IAM policy statements appended verbatim to the generated policy."
  type        = list(any)
  default     = []
}

variable "name_prefix" {
  description = "Prefix used to synthesize wildcard ARNs for services listed in prefix_managed_services. Defaults to var.name when null."
  type        = string
  default     = null
}

variable "prefix_managed_services" {
  description = "Set of services for which to auto-append wildcard ARNs based on name_prefix to their respective *_arns inputs. Supported values: iam_role, lambda_function, dynamodb_table, sns_topic, event_rule, ssm_parameter. Synthesized ARNs target the provider's current region and account."
  type        = set(string)
  default     = []

  validation {
    condition = length([
      for svc in var.prefix_managed_services :
      svc if !contains(["iam_role", "lambda_function", "dynamodb_table", "sns_topic", "event_rule", "ssm_parameter"], svc)
    ]) == 0
    error_message = "prefix_managed_services may only contain: iam_role, lambda_function, dynamodb_table, sns_topic, event_rule, ssm_parameter."
  }
}
