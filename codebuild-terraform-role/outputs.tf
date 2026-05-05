output "role_name" {
  description = "Name of the CodeBuild IAM role."
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "ID of the CodeBuild IAM role."
  value       = aws_iam_role.this.id
}

output "role_arn" {
  description = "ARN of the CodeBuild IAM role."
  value       = aws_iam_role.this.arn
}

output "policy_name" {
  description = "Name of the inline Terraform deploy policy."
  value       = aws_iam_role_policy.this.name
}
