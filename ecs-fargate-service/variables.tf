variable "name" {
  description = "Name of the application. Used to derive default ECS names."
  type        = string
}

variable "environment" {
  description = "Deployment environment tag value."
  type        = string
  default     = "prod"
}

variable "cluster_name" {
  description = "ECS cluster name. Defaults to <name>-cluster."
  type        = string
  default     = null
}

variable "service_name" {
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

variable "image" {
  description = "Container image URI, including tag."
  type        = string
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

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role."
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role."
  type        = string
}

variable "container_port" {
  description = "Container port exposed by the task and registered in Cloud Map."
  type        = number
  default     = 3000
}

variable "host_port" {
  description = "Host port for the container port mapping. Defaults to container_port."
  type        = number
  default     = null
}

variable "log_group_name" {
  description = "CloudWatch log group name used by the awslogs container log driver."
  type        = string
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
  description = "Container environment variables. Keep app-specific values in the consumer module."
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

variable "subnet_ids" {
  description = "Subnet IDs for the ECS service network configuration."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID attached to ECS tasks."
  type        = string
}

variable "assign_public_ip" {
  description = "Whether ECS tasks receive a public IP address."
  type        = bool
  default     = true
}

variable "cloudmap_service_arn" {
  description = "Cloud Map service ARN used by the ECS service registry."
  type        = string
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

variable "tags" {
  description = "Additional tags to apply to ECS resources."
  type        = map(string)
  default     = {}
}