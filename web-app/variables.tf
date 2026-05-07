variable "bucket_name" {
  description = "Name of deployment S3 bucket. Used as both the bucket name and CloudFront origin id."
  type        = string
}

variable "dns_names" {
  description = "List of CNAME aliases for the CloudFront distribution. When non-empty, acm_arn must be set to a us-east-1 ACM certificate covering all names."
  type        = list(string)
  default     = []
}

variable "acm_arn" {
  description = "ARN of an ACM certificate in us-east-1 used by CloudFront. Required when dns_names is non-empty."
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_All"
}

variable "default_root_object" {
  description = "Object that CloudFront returns for requests to the distribution root."
  type        = string
  default     = "index.html"
}

variable "spa_fallback_path" {
  description = "Path returned with HTTP 200 in place of 4xx responses to support SPA client-side routing. Set to empty string to disable."
  type        = string
  default     = "/index.html"
}

variable "force_destroy" {
  description = "Whether to force-destroy the S3 bucket on terraform destroy (deletes all objects)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags applied to module-managed resources."
  type        = map(string)
  default     = {}
}
