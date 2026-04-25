variable "name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "billing_mode" {
  description = "DynamoDB billing mode."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Hash key attribute name."
  type        = string
  default     = "PK"
}

variable "range_key" {
  description = "Range key attribute name."
  type        = string
  default     = "SK"
}

variable "attributes" {
  description = "Table attributes used by the primary key and any secondary indexes."
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "PK"
      type = "S"
    },
    {
      name = "SK"
      type = "S"
    },
  ]
}

variable "global_secondary_indexes" {
  description = "Global secondary indexes to create on the table."
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = optional(string, "ALL")
    non_key_attributes = optional(list(string))
  }))
  default = []
}

variable "ttl_enabled" {
  description = "Whether DynamoDB TTL is enabled."
  type        = bool
  default     = true
}

variable "ttl_attribute_name" {
  description = "Attribute name used for TTL."
  type        = string
  default     = "ttl"
}

variable "tags" {
  description = "Tags to apply to the table."
  type        = map(string)
  default     = {}
}