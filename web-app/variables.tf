variable "bucket_name" {
  description = "Name of deployment S3 bucket"
}

variable "dns_names" {
  description = "List of DNS names for app"
  type = "list"
}

variable "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
}

variable "acm_arn" {
  description = "ARN of ACM SSL certificate"
}