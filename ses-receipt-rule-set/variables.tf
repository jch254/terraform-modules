variable "name" {
  description = "Name of the SES receipt rule set."
  type        = string
}

variable "activate" {
  description = "Whether to make this receipt rule set active in the current AWS account and region. Defaults to false because SES allows only one active receipt rule set per account/region."
  type        = bool
  default     = false
}
