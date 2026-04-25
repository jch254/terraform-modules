# Terraform Modules

Reusable Terraform modules for small AWS application infrastructure.

This repository contains common infrastructure building blocks that can be referenced from application repositories using a Git source, tag, and module subfolder. The goal is to keep repeated infrastructure patterns in one place while letting each application own its own deployment, configuration, secrets, domains, and product-specific choices.

Modules are intended to be small and composable rather than one large "app" module. This keeps migrations safer, makes Terraform plans easier to review, and allows projects to adopt modules gradually.

Example:

```hcl
module "ecr_repository" {
  source = "github.com/jch254/terraform-modules//ecr-repository?ref=1.1.0"

  name = "reference-architecture"
  tags = local.tags
}
```

## Why this repo exists

A few of my projects now use the same low-cost AWS app pattern:

- ECR for container images
- DynamoDB for app storage
- CodeBuild for CI/CD
- ECS Fargate for runtime
- API Gateway HTTP API with VPC Link
- Cloud Map for service discovery
- CloudWatch logs
- Cloudflare DNS at the app edge

Keeping those patterns in a module repo makes new projects faster to scaffold and reduces drift between apps.

The intended layering is:

```text
terraform-modules
  reusable infrastructure primitives

reference-architecture
  public runnable scaffold composed from those modules

real apps
  product-specific code, config, secrets, domains, and data model choices
```

## Module inventory

### Current app modules

| Module | Purpose |
| --- | --- |
| `ecr-repository` | ECR repository for container images, with optional lifecycle policy and image scanning settings. |
| `dynamodb-single-table` | DynamoDB single-table module with optional range key, TTL, and configurable GSIs. |
| `codebuild-project` | Standalone CodeBuild project module, extended for current ECS deployment pipelines. |
| `app-log-group` | CloudWatch application log group for ECS runtime logs. |
| `app-runtime-iam` | ECS task execution role, task role, and runtime IAM policies. |
| `app-security-groups` | API Gateway VPC Link and ECS task security groups. |
| `cloudmap-private-service` | Cloud Map private DNS namespace and service for ECS service discovery. |
| `ecs-fargate-service` | ECS Fargate cluster, task definition, and service. |
| `http-api-cloudmap-proxy` | API Gateway HTTP API, VPC Link, Cloud Map integration, route, and stage. |

### Legacy modules

These are kept for older projects and backwards compatibility.

| Module | Purpose |
| --- | --- |
| `build-pipeline` | Legacy CodePipeline and CodeBuild pipeline module for older GitHub OAuth based deployments. |
| `lambda-function` | Legacy Lambda packaging and deployment helper. |
| `web-app` | Legacy S3 and CloudFront static web app module. |
| `web-app-redirect` | Legacy S3 and CloudFront redirect module. |

`web-app` and `web-app-redirect` should not be overloaded with the ECS/API Gateway pattern. They remain static-hosting helpers.

## Current app stack direction

The current app stack is composed from small modules rather than a single app module.

Phase 1 added the lower-risk building blocks:

- `ecr-repository`
- `dynamodb-single-table`
- backwards-compatible updates to `codebuild-project`

Phase 2 added runtime-edge building blocks:

- `app-log-group`
- `app-runtime-iam`
- `app-security-groups`
- `cloudmap-private-service`
- `ecs-fargate-service`
- `http-api-cloudmap-proxy`

Cloudflare DNS, build notifications, and SES routing are intentionally separate concerns and should be added as focused modules later if enough projects converge on the same shape.

## Usage

Reference a module by repository URL, subfolder, and tag:

```hcl
module "dynamodb_single_table" {
  source = "github.com/jch254/terraform-modules//dynamodb-single-table?ref=1.1.0"

  name          = "reference-architecture-entities"
  hash_key      = "PK"
  range_key     = "SK"
  ttl_enabled   = true
  ttl_attribute = "expiresAt"
  tags          = local.tags
}
```

For modules used in deployed apps, pin to a tag rather than a branch:

```hcl
source = "github.com/jch254/terraform-modules//ecs-fargate-service?ref=1.2.0"
```

## Migration approach

When moving existing root Terraform resources into modules, preserve resource identity first.

Recommended flow:

1. Add or update the module in this repo.
2. Tag the module release.
3. Update the consuming app to use the tagged module.
4. Add `moved` blocks or run explicit `terraform state mv` commands.
5. Run a remote-state plan.
6. Require no create/destroy for long-lived infrastructure.

For sensitive resources such as ECS services, API Gateway APIs, Cloud Map namespaces, security groups, DynamoDB tables, and ECR repositories, the target should be:

```text
Plan: 0 to add, 0 to change, 0 to destroy
```

ECS task definition revision churn may be acceptable if it is understood and documented. ECS service replacement is not acceptable.

## Development

Format modules before committing:

```bash
terraform fmt -recursive
```

For targeted validation:

```bash
cd <module-name>
terraform init -backend=false
terraform validate
```

Some legacy modules may require older Terraform/provider assumptions. Prefer targeted validation for changed modules unless doing a larger maintenance pass.

## Release notes

Use tags for app consumption.

Example release shape:

- `1.1.0`: current-gen low-risk modules, including ECR and DynamoDB, plus CodeBuild updates.
- `1.1.1`: CodeBuild log group management made optional for parity-safe migration.
- `1.2.0`: runtime-edge modules for ECS Fargate, Cloud Map, API Gateway, runtime IAM, security groups, and logs.

## License

MIT
