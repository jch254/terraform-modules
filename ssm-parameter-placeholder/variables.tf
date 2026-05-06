variable "name" {
  description = "Name of the SSM parameter (e.g. /my-app/cookie-secret)."
  type        = string
}

variable "description" {
  description = "Description for the SSM parameter."
  type        = string
  default     = null
}

variable "type" {
  description = "Parameter type. One of String, StringList, SecureString."
  type        = string
  default     = "SecureString"
}

variable "placeholder_value" {
  description = "Initial placeholder value written on creation. The real value is expected to be set out-of-band (console/CLI); subsequent changes to value are ignored."
  type        = string
  default     = "placeholder"
}

variable "tier" {
  description = "Parameter tier (Standard, Advanced, Intelligent-Tiering)."
  type        = string
  default     = null
}

variable "key_id" {
  description = "Optional KMS key ID for SecureString parameters. Defaults to the AWS-managed alias/aws/ssm key when null."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the parameter."
  type        = map(string)
  default     = {}
}
