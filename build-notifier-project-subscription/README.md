# build-notifier-project-subscription

Creates an app-owned EventBridge subscription for one or more CodeBuild projects and targets the shared build notification formatter Lambda.

Use this with the shared `build-notifier` core module when each app repo should opt itself into account-level build notifications without deploying its own formatter Lambda or SNS topic.

## Example

```hcl
module "build_notifier_subscription" {
  source = "github.com/jch254/terraform-modules//build-notifier-project-subscription?ref=1.8.1"

  name                = var.name
  environment         = var.environment
  lambda_function_arn = local.shared_build_notifier_lambda_arn
  app_url             = "https://${var.dns_name}"
  github_repo_url     = trimsuffix(var.source_location, ".git")

  codebuild_project_names = [module.codebuild_project.project_name]
}
```

The module creates:

- EventBridge rule scoped to CodeBuild `SUCCEEDED` / `FAILED` state changes for `codebuild_project_names`
- EventBridge target pointing at the shared formatter Lambda
- Lambda invoke permission scoped to the EventBridge rule ARN

App metadata is passed to the shared Lambda through an EventBridge input transformer, so the shared platform repo does not need to know every subscribing project.

## Inputs

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| `name` | Resource name prefix. | `string` | required |
| `environment` | Environment tag value. | `string` | required |
| `lambda_function_arn` | ARN of the shared build notification formatter Lambda. | `string` | required |
| `codebuild_project_names` | CodeBuild project names whose state changes trigger notifications. | `list(string)` | required |
| `app_url` | Public application URL included in the notification body. | `string` | `""` |
| `github_repo_url` | Repository URL used for commit links. | `string` | `""` |

## Outputs

| Name | Description |
| --- | --- |
| `event_rule_arn` | ARN of the EventBridge rule. |
| `event_rule_name` | Name of the EventBridge rule. |
