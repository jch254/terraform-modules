# codebuild-terraform-role

Creates the IAM role and inline policy used by CodeBuild projects that run Terraform.

The module is intentionally generic across project shapes. Consumers opt into AWS resource families by passing ARNs or enabling capability flags, while the module owns the repeated CodeBuild trust policy and Terraform deploy permission skeleton.

## Example

```hcl
module "codebuild_terraform_role" {
  source = "github.com/jch254/terraform-modules//codebuild-terraform-role?ref=1.10.0"

  name        = var.name
  environment = var.environment

  s3_read_write_resource_arns = ["*"]
  ecr_repository_arns         = [module.ecr_repository.repository_arn]
  enable_ecs                  = true
  enable_ec2_networking       = true
  enable_api_gateway          = true
  enable_service_discovery    = true
  enable_route53              = true

  iam_role_arns       = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.name}-*"]
  codebuild_project_arns = ["*"]
  ssm_parameter_arns  = ["arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${var.name}/*"]
  dynamodb_table_arns = ["arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.name}-*"]
  event_rule_arns     = ["arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:rule/${var.name}-*"]

  lambda_permission_function_arns = [local.shared_build_notifier_lambda_arn]

  tags = {
    Environment = var.environment
  }
}
```

For platform/shared roots, pass only the resource families they actually manage, for example SES, SNS, Lambda, EventBridge, IAM, S3 state/cache, and CodeBuild.

## Notes

- `sts:GetCallerIdentity` is always included because Terraform and deploy scripts commonly use it.
- `additional_policy_statements` is available for project-specific edge cases, but prefer adding a focused input when the permission is likely to recur.
- S3 can be modeled broadly with `s3_read_write_resource_arns = ["*"]` for parity migrations, or more tightly with `s3_bucket_arns` and `s3_object_arns`.
