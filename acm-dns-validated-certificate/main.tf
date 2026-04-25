locals {
  subject_alternative_names = sort(distinct(var.subject_alternative_names))

  validation_record_names = sort(distinct([
    for option in aws_acm_certificate.main.domain_validation_options : option.resource_record_name
  ]))
}

resource "aws_acm_certificate" "main" {
  domain_name               = var.domain_name
  subject_alternative_names = length(local.subject_alternative_names) > 0 ? local.subject_alternative_names : null
  validation_method         = var.validation_method

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
