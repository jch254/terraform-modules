variable "domain_name" {
  description = "Primary domain name for the ACM certificate."
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional subject alternative names for the ACM certificate. Values are de-duplicated and sorted for stable plans."
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "ACM certificate validation method. DNS is required for DNS validation record outputs."
  type        = string
  default     = "DNS"

  validation {
    condition     = contains(["DNS"], var.validation_method)
    error_message = "validation_method must be DNS."
  }
}

variable "tags" {
  description = "Tags to apply to the ACM certificate."
  type        = map(string)
  default     = {}
}
