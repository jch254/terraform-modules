variable "name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Whether images are scanned after being pushed."
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Whether to delete the repository even if it contains images."
  type        = bool
  default     = false
}

variable "lifecycle_policy_json" {
  description = "Optional ECR lifecycle policy JSON."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to repository resources."
  type        = map(string)
  default     = {}
}