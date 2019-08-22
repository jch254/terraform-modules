output "badge_url" {
  value = var.badge_enabled != true ? "" : aws_codebuild_project.codebuild_project.badge_url
}
