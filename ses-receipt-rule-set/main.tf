resource "aws_ses_receipt_rule_set" "main" {
  rule_set_name = var.name
}

resource "aws_ses_active_receipt_rule_set" "main" {
  count = var.activate ? 1 : 0

  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
}
