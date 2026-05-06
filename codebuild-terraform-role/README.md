# codebuild-terraform-role

Creates the IAM role and inline policy used by CodeBuild projects that run Terraform.

The module is intentionally generic across project shapes. Consumers opt into AWS resource families by passing ARNs or enabling capability flags, while the module owns the repeated CodeBuild trust policy and Terraform deploy permission skeleton.

## Example

```hcl
module "codebuild_terraform_role" {
  source = "github.com/jch254/terraform-modules//codebuild-terraform-role?ref=1.12.0"

  name        = var.name
  environment = var.environment
  assume_role_services = [
    "codebuild.amazonaws.com",
    "codebuild.${var.region}.amazonaws.com",
  ]

  s3_read_write_resource_arns = ["*"]
  ecr_repository_arns         = [module.ecr_repository.repository_arn]
  enable_ecs                  = true
  enable_ec2_networking       = true
  enable_api_gateway          = true
  enable_service_discovery    = true
  enable_route53              = true

  codebuild_project_arns = ["*"]

  prefix_managed_services = [
    "iam_role",
    "ssm_parameter",
    "dynamodb_table",
    "event_rule",
    "lambda_function",
    "sns_topic",
  ]

  lambda_permission_function_arns = [local.shared_build_notifier_lambda_arn]
}
```

For platform/shared roots, pass only the resource families they actually manage, for example SES, SNS, Lambda, EventBridge, IAM, S3 state/cache, and CodeBuild. When wildcard ARNs need to target a different region than the provider's region (e.g. a build notifier in another region), pass them explicitly via the per-service `*_arns` inputs instead of using `prefix_managed_services` for that service.

## Notes

- `sts:GetCallerIdentity` is always included because Terraform and deploy scripts commonly use it.
- `additional_policy_statements` is available for project-specific edge cases, but prefer adding a focused input when the permission is likely to recur.
- S3 can be modeled broadly with `s3_read_write_resource_arns = ["*"]` for parity migrations, or more tightly with `s3_bucket_arns` and `s3_object_arns`.
- `prefix_managed_services` synthesizes wildcard ARNs from `name_prefix` (defaulting to `var.name`) for the listed services. Synthesized ARNs target the provider's current region and account. Synthesized entries are appended to any explicit `*_arns` you pass — both coexist.
