variable "domain_name" {
  description = "Custom domain name to attach to API Gateway."
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the API Gateway custom domain."
  type        = string
}

variable "api_id" {
  description = "API Gateway HTTP API ID to map to the custom domain."
  type        = string
}

variable "stage" {
  description = "API Gateway stage ID or name to map to the custom domain."
  type        = string
}

variable "endpoint_type" {
  description = "API Gateway custom domain endpoint type."
  type        = string
  default     = "REGIONAL"
}

variable "security_policy" {
  description = "TLS security policy for the API Gateway custom domain."
  type        = string
  default     = "TLS_1_2"
}

variable "tags" {
  description = "Tags to apply to the API Gateway custom domain."
  type        = map(string)
  default     = {}
}
