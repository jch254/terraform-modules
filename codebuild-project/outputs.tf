output "badge_url" {
  value = var.badge_enabled != true ? "" : aws_codebuild_project.codebuild_project.badge_url
}

output "project_name" {
  value = aws_codebuild_project.codebuild_project.name
}

output "project_arn" {
  value = aws_codebuild_project.codebuild_project.arn
}

output "project_id" {
  value = aws_codebuild_project.codebuild_project.id
}

output "build_notification_event_rule_arn" {
  description = "ARN of the optional app-owned EventBridge rule targeting the shared build notifier."
  value       = var.build_notifier_lambda_function_arn == "" ? "" : module.build_notifier_subscription[0].event_rule_arn
}

output "build_notification_event_rule_name" {
  description = "Name of the optional app-owned EventBridge rule targeting the shared build notifier."
  value       = var.build_notifier_lambda_function_arn == "" ? "" : module.build_notifier_subscription[0].event_rule_name
}
