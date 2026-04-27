# build-notifier

Deploys the shared build notification core: an SNS topic, email subscription, and Lambda formatter that publishes formatted CodeBuild build notifications.

Apps can opt in by using `build-notifier-project-subscription`, which creates an app-owned EventBridge rule and Lambda permission targeting this shared formatter. For backwards-compatible single-root deployments, this module can still create an EventBridge rule when `codebuild_project_names` is non-empty.

Internally:

- SNS topic + email subscription
- Lambda formatter (Node.js, vendored at `lambda/dist/index.js`) that turns the EventBridge event into a readable subject + multi-line body and publishes to SNS
- IAM role + inline policy for the Lambda (`sns:Publish` on the topic, CloudWatch Logs)
- optional EventBridge rule, Lambda invoke permission, and EventBridge target when `codebuild_project_names` is set

The formatter pulls the commit SHA and message from CodeBuild [exported environment variables](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec-ref-syntax) (`COMMIT_SHA`, `COMMIT_MESSAGE`) when present, falling back to `CODEBUILD_SOURCE_VERSION`. Export them in your buildspec to get a meaningful subject line:

```yaml
phases:
  build:
    commands:
      - export COMMIT_SHA=$CODEBUILD_RESOLVED_SOURCE_VERSION
      - export COMMIT_MESSAGE=$(git log -1 --pretty=%s)
exported-variables:
  - COMMIT_SHA
  - COMMIT_MESSAGE
```

## Example

```hcl
module "build_notifier" {
  source = "git::https://github.com/jch254/terraform-modules.git//build-notifier?ref=<version>"

  name               = var.name
  environment        = var.environment
  notification_email = var.notification_email
}
```

Then subscribe an app-owned CodeBuild project from the app repo:

```hcl
module "build_notifier_subscription" {
  source = "git::https://github.com/jch254/terraform-modules.git//build-notifier-project-subscription?ref=<version>"

  name                = var.name
  environment         = var.environment
  lambda_function_arn = module.build_notifier.lambda_function_arn
  app_url             = "https://${var.dns_name}"
  github_repo_url     = trimsuffix(var.source_location, ".git")

  codebuild_project_names = [module.codebuild_project.project_name]
}
```

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `name` | Resource name prefix. | `string` | required |
| `environment` | Environment tag value. | `string` | required |
| `notification_email` | Email subscribed to the SNS topic. | `string` | required |
| `codebuild_project_names` | Optional CodeBuild project names whose state changes trigger notifications from this module. Leave empty when app repos subscribe with `build-notifier-project-subscription`. | `list(string)` | `[]` |
| `app_url` | Public application URL surfaced in the notification body for optional inline subscriptions. | `string` | `""` |
| `github_repo_url` | Repository URL used for commit links for optional inline subscriptions. | `string` | `""` |
| `lambda_runtime` | Lambda runtime for the formatter. | `string` | `"nodejs20.x"` |

## Outputs

| Name | Description |
| --- | --- |
| `sns_topic_arn` | ARN of the SNS topic. |
| `lambda_function_name` | Formatter Lambda function name. |
| `lambda_function_arn` | Formatter Lambda function ARN. |
| `event_rule_arn` | EventBridge rule ARN when `codebuild_project_names` is non-empty. |

## Modifying the formatter

The Lambda source lives at `lambda/index.ts` and the bundled artifact at `lambda/dist/index.js`. To rebuild after editing:

```sh
npx esbuild lambda/index.ts \
  --bundle --platform=node --target=node20 \
  --format=cjs --external:@aws-sdk/* \
  --outfile=lambda/dist/index.js
```

Commit both `index.ts` and `dist/index.js` so consumers don't need a build step. `data.archive_file.lambda` zips `dist/index.js` and `source_code_hash` ensures the Lambda is updated when the bundle changes.

## Migration from inline resources

If you previously had the same shape inlined at the root module — top-level `aws_sns_topic.build_notifications`, `aws_lambda_function.build_notification_formatter`, `aws_cloudwatch_event_rule.build_notifications`, etc. — move state into the module without recreating anything:

```hcl
moved {
  from = aws_sns_topic.build_notifications
  to   = module.build_notifier.aws_sns_topic.this
}

moved {
  from = aws_sns_topic_subscription.build_email
  to   = module.build_notifier.aws_sns_topic_subscription.email
}

moved {
  from = aws_iam_role.build_notification_lambda
  to   = module.build_notifier.aws_iam_role.lambda
}

moved {
  from = aws_iam_role_policy.build_notification_lambda
  to   = module.build_notifier.aws_iam_role_policy.lambda
}

moved {
  from = aws_lambda_function.build_notification_formatter
  to   = module.build_notifier.aws_lambda_function.formatter
}

moved {
  from = aws_lambda_permission.build_notification_eventbridge
  to   = module.build_notifier.aws_lambda_permission.eventbridge[0]
}

moved {
  from = aws_cloudwatch_event_rule.build_notifications
  to   = module.build_notifier.aws_cloudwatch_event_rule.this[0]
}

moved {
  from = aws_cloudwatch_event_target.build_notifications
  to   = module.build_notifier.aws_cloudwatch_event_target.lambda[0]
}
```

`data.archive_file` is recreated rather than moved (data sources have no persistent state). The Lambda's `source_code_hash` will match if the bundled `dist/index.js` is byte-identical to the previously-deployed artifact; otherwise the Lambda code is updated in place — no replacement.

The resource `Name` and `Environment` tags are preserved exactly. Verify with `terraform plan`: every moved record should show with no create / update / replace.
