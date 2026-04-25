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
