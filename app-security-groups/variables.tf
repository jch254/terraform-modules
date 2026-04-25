variable "name" {
  description = "Name of the application. Used in security group names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "vpc_id" {
  description = "ID of the VPC where the security groups are created."
  type        = string
}

variable "container_port" {
  description = "Container port allowed from the API Gateway VPC Link security group to ECS tasks."
  type        = number
  default     = 3000
}

variable "tags" {
  description = "Additional tags to apply to the security groups."
  type        = map(string)
  default     = {}
}