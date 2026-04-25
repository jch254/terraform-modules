variable "name" {
  description = "Name of the application. Used to derive default API Gateway names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "subnet_ids" {
  description = "Subnet IDs used by the API Gateway VPC Link."
  type        = list(string)
}

variable "vpc_link_security_group_ids" {
  description = "Security group IDs attached to the API Gateway VPC Link."
  type        = list(string)
}

variable "cloudmap_service_arn" {
  description = "Cloud Map service ARN used as the HTTP proxy integration URI."
  type        = string
}

variable "route_key" {
  description = "HTTP API route key."
  type        = string
  default     = "$default"
}

variable "stage_name" {
  description = "HTTP API stage name."
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Whether API Gateway automatically deploys changes to the stage."
  type        = bool
  default     = true
}

variable "integration_method" {
  description = "HTTP method used by the Cloud Map HTTP proxy integration."
  type        = string
  default     = "ANY"
}

variable "tags" {
  description = "Additional tags to apply to API Gateway resources."
  type        = map(string)
  default     = {}
}