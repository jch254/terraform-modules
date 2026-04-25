variable "name" {
  description = "Name of the SES receipt rule."
  type        = string
}

variable "rule_set_name" {
  description = "Name of the SES receipt rule set that owns this rule."
  type        = string
}

variable "recipients" {
  description = "Recipient domains or addresses that this rule matches."
  type        = list(string)
}

variable "enabled" {
  description = "Whether the SES receipt rule is enabled."
  type        = bool
  default     = true
}

variable "scan_enabled" {
  description = "Whether SES spam and virus scanning is enabled for this rule."
  type        = bool
  default     = true
}

variable "tls_policy" {
  description = "TLS policy for mail accepted by this receipt rule. Valid values are Optional or Require."
  type        = string
  default     = "Optional"

  validation {
    condition     = contains(["Optional", "Require"], var.tls_policy)
    error_message = "tls_policy must be either Optional or Require."
  }
}

variable "s3_bucket_name" {
  description = "S3 bucket name where SES stores raw inbound messages."
  type        = string
}

variable "s3_object_key_prefix" {
  description = "Optional S3 object key prefix for raw inbound messages."
  type        = string
  default     = ""
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function invoked by the receipt rule."
  type        = string
}

variable "lambda_invocation_type" {
  description = "Lambda invocation type for the SES action. Valid values are Event or RequestResponse."
  type        = string
  default     = "Event"

  validation {
    condition     = contains(["Event", "RequestResponse"], var.lambda_invocation_type)
    error_message = "lambda_invocation_type must be either Event or RequestResponse."
  }
}

variable "after" {
  description = "Optional receipt rule name that this rule should be placed after."
  type        = string
  default     = null
}

variable "s3_position" {
  description = "Position of the S3 action in the SES receipt rule action list."
  type        = number
  default     = 1
}

variable "lambda_position" {
  description = "Position of the Lambda action in the SES receipt rule action list."
  type        = number
  default     = 2
}
