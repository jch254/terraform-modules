output "name" {
  description = "Name of the SES receipt rule."
  value       = aws_ses_receipt_rule.main.name
}

output "rule_set_name" {
  description = "Name of the SES receipt rule set that owns this rule."
  value       = aws_ses_receipt_rule.main.rule_set_name
}

output "id" {
  description = "Terraform provider ID of the SES receipt rule."
  value       = aws_ses_receipt_rule.main.id
}
