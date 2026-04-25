variable "name" {
  description = "Name of the application. Used to derive default Cloud Map names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "vpc_id" {
  description = "ID of the VPC associated with the private DNS namespace."
  type        = string
}

variable "namespace_name" {
  description = "Private DNS namespace name. Defaults to <name>.local."
  type        = string
  default     = null
}

variable "service_name" {
  description = "Cloud Map service name. Defaults to <name>-service."
  type        = string
  default     = null
}

variable "dns_record_type" {
  description = "Cloud Map DNS record type."
  type        = string
  default     = "SRV"
}

variable "dns_record_ttl" {
  description = "Cloud Map DNS record TTL in seconds."
  type        = number
  default     = 1
}

variable "routing_policy" {
  description = "Cloud Map DNS routing policy."
  type        = string
  default     = "MULTIVALUE"
}

variable "failure_threshold" {
  description = "Custom health check failure threshold."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional tags to apply to Cloud Map resources."
  type        = map(string)
  default     = {}
}