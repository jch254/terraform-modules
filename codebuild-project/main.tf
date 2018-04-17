resource "aws_cloudwatch_log_group" "codebuild_lg" {
  name              = "/aws/codebuild/${var.name}"
  retention_in_days = "${var.log_retention}"
}

resource "aws_codebuild_project" "codebuild_project" {
  name         = "${var.name}"
  description  = "Builds, tests and deploys ${var.name}"
  service_role = "${var.codebuild_role_arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "${var.build_compute_type}"
    image           = "${var.build_docker_image}:${var.build_docker_tag}"
    type            = "LINUX_CONTAINER"
    privileged_mode = "${var.privileged_mode}"
  }

  source {
    type      = "${var.source_type}"
    buildspec = "${var.buildspec}"
    location  = "${var.source_location}"
  }
}
