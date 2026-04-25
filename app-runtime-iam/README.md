# app-runtime-iam

Manages the IAM roles and policies used by ECS tasks at runtime.

This module owns:

- ECS task execution role
- `AmazonECSTaskExecutionRolePolicy` attachment
- execution role SSM parameter read policy
- ECS task role
- task role DynamoDB table access policy

## Example

```hcl
module "app_runtime_iam" {
  source = "git::https://github.com/jch254/terraform-modules.git//app-runtime-iam?ref=<version>"

  name        = var.name
  environment = var.environment
  region      = var.region

  ssm_parameter_arns = [
    aws_ssm_parameter.cookie_secret.arn,
    aws_ssm_parameter.resend_api_key.arn,
  ]

  dynamodb_table_arn = module.dynamodb_single_table.table_arn

  tags = {
    Environment = var.environment
  }
}
```

Role and policy names preserve the current reference-architecture shape: `${name}-ecs-execution-role`, `${name}-ecs-execution-ssm`, `${name}-ecs-task-role`, and `${name}-ecs-task-dynamodb`.

## Migration Notes

Move existing IAM resources into this module before applying. The ECS service module should depend on this module during consumer migration so task registration does not race ahead of the SSM execution policy.

Expected move targets:

```hcl
moved { from = aws_iam_role.ecs_execution_role to = module.app_runtime_iam.aws_iam_role.ecs_execution_role }
moved { from = aws_iam_role_policy_attachment.ecs_execution_role_policy to = module.app_runtime_iam.aws_iam_role_policy_attachment.ecs_execution_role_policy }
moved { from = aws_iam_role_policy.ecs_execution_ssm to = module.app_runtime_iam.aws_iam_role_policy.ecs_execution_ssm }
moved { from = aws_iam_role.ecs_task_role to = module.app_runtime_iam.aws_iam_role.ecs_task_role }
moved { from = aws_iam_role_policy.ecs_task_dynamodb to = module.app_runtime_iam.aws_iam_role_policy.ecs_task_dynamodb }
```

After the move, confirm the plan does not replace IAM roles or broaden policy scope unexpectedly.