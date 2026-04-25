output "arn" {
  description = "ARN of the ACM certificate."
  value       = aws_acm_certificate.main.arn
}

output "domain_name" {
  description = "Primary domain name on the ACM certificate."
  value       = aws_acm_certificate.main.domain_name
}

output "domain_validation_options" {
  description = "Raw ACM domain validation options."
  value       = aws_acm_certificate.main.domain_validation_options
}

output "validation_records" {
  description = "DNS validation records keyed by record name, de-duplicated for apex plus wildcard certificates."
  value = {
    for record_name in local.validation_record_names : record_name => {
      name = record_name
      type = element(distinct([
        for option in aws_acm_certificate.main.domain_validation_options : option.resource_record_type
        if option.resource_record_name == record_name
      ]), 0)
      value = element(distinct([
        for option in aws_acm_certificate.main.domain_validation_options : option.resource_record_value
        if option.resource_record_name == record_name
      ]), 0)
      domain_names = sort([
        for option in aws_acm_certificate.main.domain_validation_options : option.domain_name
        if option.resource_record_name == record_name
      ])
    }
  }
}
