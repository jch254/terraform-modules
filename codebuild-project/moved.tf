moved {
  from = aws_cloudwatch_log_group.codebuild_lg
  to   = aws_cloudwatch_log_group.codebuild_lg[0]
}
