output "domain" {
  description = "SES domain identity domain."
  value       = aws_ses_domain_identity.main.domain
}

output "verification_token" {
  description = "SES domain verification token for the _amazonses.<domain> TXT record."
  value       = aws_ses_domain_identity.main.verification_token
}

output "dkim_tokens" {
  description = "SES Easy DKIM tokens for <token>._domainkey.<domain> CNAME records."
  value       = aws_ses_domain_dkim.main.dkim_tokens
}

output "identity_arn" {
  description = "ARN of the SES domain identity."
  value       = aws_ses_domain_identity.main.arn
}
