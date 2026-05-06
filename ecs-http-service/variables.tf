variable "name" {
  description = "Name of the application. Used to derive default resource names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "vpc_id" {
  description = "ID of the VPC where the service runs."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs used by API Gateway VPC Link and ECS tasks."
  type        = list(string)
}

variable "image" {
  description = "Container image URI, including tag."
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role."
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role."
  type        = string
}

variable "container_port" {
  description = "Container port exposed by the task and proxied by API Gateway."
  type        = number
  default     = 3000
}

variable "host_port" {
  description = "Host port for the container port mapping. Defaults to container_port."
  type        = number
  default     = null
}

variable "cluster_name" {
  description = "ECS cluster name. Defaults to <name>-cluster."
  type        = string
  default     = null
}

variable "ecs_service_name" {
  description = "ECS service name. Defaults to <name>-service."
  type        = string
  default     = null
}

variable "task_family" {
  description = "ECS task definition family. Defaults to <name>."
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name in the task definition. Defaults to <name>."
  type        = string
  default     = null
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MB."
  type        = number
  default     = 512
}

variable "log_group_name" {
  description = "CloudWatch log group name used by the awslogs container log driver. Defaults to /ecs/<name>."
  type        = string
  default     = null
}

variable "create_log_group" {
  description = "Whether to create the CloudWatch log group used by the ECS task."
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Number of days to retain application logs when create_log_group is true."
  type        = number
  default     = 7
}

variable "log_group_tags" {
  description = "Additional tags to apply to the CloudWatch log group when create_log_group is true."
  type        = map(string)
  default     = {}
}

variable "log_region" {
  description = "AWS region used by the awslogs container log driver."
  type        = string
}

variable "log_stream_prefix" {
  description = "CloudWatch Logs stream prefix for ECS containers."
  type        = string
  default     = "ecs"
}

variable "environment_variables" {
  description = "Container environment variables."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Container secrets, usually SSM parameter or Secrets Manager ARNs."
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "health_check" {
  description = "Container health check block encoded into the task definition."
  type = object({
    command     = list(string)
    interval    = number
    timeout     = number
    retries     = number
    startPeriod = number
  })
  default = {
    command     = ["CMD-SHELL", "wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1"]
    interval    = 15
    timeout     = 5
    retries     = 3
    startPeriod = 60
  }
}

variable "essential" {
  description = "Whether the container is essential to the task."
  type        = bool
  default     = true
}

variable "assign_public_ip" {
  description = "Whether ECS tasks receive a public IP address."
  type        = bool
  default     = true
}

variable "desired_count" {
  description = "Desired ECS service task count."
  type        = number
  default     = 1
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit on healthy tasks during deployment."
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Upper limit on running tasks during deployment."
  type        = number
  default     = 200
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore unhealthy service checks after task startup."
  type        = number
  default     = 60
}

variable "deployment_circuit_breaker_enable" {
  description = "Whether the ECS deployment circuit breaker is enabled."
  type        = bool
  default     = true
}

variable "deployment_circuit_breaker_rollback" {
  description = "Whether ECS rolls back failed deployments when the circuit breaker trips."
  type        = bool
  default     = true
}

variable "container_insights" {
  description = "ECS cluster containerInsights setting."
  type        = string
  default     = "disabled"
}

variable "operating_system_family" {
  description = "Task runtime platform operating system family."
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "Task runtime platform CPU architecture."
  type        = string
  default     = "X86_64"
}

variable "cloudmap_namespace_name" {
  description = "Private DNS namespace name. Defaults to <name>.local."
  type        = string
  default     = null
}

variable "cloudmap_service_name" {
  description = "Cloud Map service name. Defaults to <name>-service."
  type        = string
  default     = null
}

variable "cloudmap_dns_record_type" {
  description = "Cloud Map DNS record type."
  type        = string
  default     = "SRV"
}

variable "cloudmap_dns_record_ttl" {
  description = "Cloud Map DNS record TTL in seconds."
  type        = number
  default     = 1
}

variable "cloudmap_routing_policy" {
  description = "Cloud Map DNS routing policy."
  type        = string
  default     = "MULTIVALUE"
}

variable "cloudmap_failure_threshold" {
  description = "Custom health check failure threshold."
  type        = number
  default     = 1
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

variable "access_log_destination_arn" {
  description = "Optional CloudWatch log group ARN for HTTP API stage access logs."
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "Optional HTTP API stage access log format. Used only when access_log_destination_arn is set."
  type        = string
  default     = null
}

variable "integration_method" {
  description = "HTTP method used by the Cloud Map HTTP proxy integration."
  type        = string
  default     = "ANY"
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}
