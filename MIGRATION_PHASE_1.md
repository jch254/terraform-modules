# Phase 1 Migration Note

Reference architecture should consume these modules next, one block at a time, while preserving Terraform plan parity:

1. Replace the inline ECR repository with `ecr-repository`.
2. Replace the inline DynamoDB entities table with `dynamodb-single-table`.
3. Replace the inline CodeBuild project and webhook with the updated `codebuild-project` module.

For an existing deployed stack, move state addresses before applying module-backed configuration. The migration should not replace the ECR repository, DynamoDB table, CodeBuild project, CodeBuild log group, or CodeBuild webhook.

Suggested state moves for reference architecture:

```bash
terraform state mv aws_ecr_repository.main module.ecr.aws_ecr_repository.main
terraform state mv aws_dynamodb_table.entities module.entities.aws_dynamodb_table.main
terraform state mv aws_cloudwatch_log_group.codebuild_lg module.codebuild.aws_cloudwatch_log_group.codebuild_lg
terraform state mv aws_codebuild_project.main module.codebuild.aws_codebuild_project.codebuild_project
terraform state mv aws_codebuild_webhook.main module.codebuild.aws_codebuild_webhook.codebuild_webhook[0]
```

After each move, run `terraform plan` and confirm there are no create, destroy, or replacement actions for migrated resources. ECS, API Gateway, Cloud Map, Cloudflare, build notification, and SES modules are intentionally out of scope for phase 1.