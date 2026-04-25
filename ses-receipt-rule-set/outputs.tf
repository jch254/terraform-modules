output "name" {
  description = "Name of the SES receipt rule set."
  value       = aws_ses_receipt_rule_set.main.rule_set_name
}

output "id" {
  description = "Terraform provider ID of the SES receipt rule set."
  value       = aws_ses_receipt_rule_set.main.id
}

output "active_rule_set_name" {
  description = "Active receipt rule set name when activate is true, otherwise null."
  value       = var.activate ? aws_ses_active_receipt_rule_set.main[0].rule_set_name : null
}
