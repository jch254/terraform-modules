# Terraform Modules

Reusable Terraform modules for small AWS and Cloudflare application infrastructure.

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
- ACM certificates and API Gateway custom domains
- Cloud Map for service discovery
- CloudWatch logs
- Cloudflare DNS at the app edge

Keeping those patterns in a module repo makes new projects faster to scaffold and reduces drift between apps.

The intended layering is:

```text
terraform-modules
  reusable infrastructure primitives

reference-architecture
  public runnable scaffold composed from those modules; first full consumer of the current module set

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
| `acm-dns-validated-certificate` | ACM certificate and validation wait resource for DNS-validated app domains. |
| `api-gateway-custom-domain` | API Gateway HTTP API custom domain and API mapping. |
| `cloudflare-dns-records` | Generic Cloudflare DNS records module driven by a typed `records` map. Replaces the per-purpose ACM-validation, API-CNAME, SES-verification, and SES-inbound-MX modules. |
| `ses-domain-identity` | SES domain identity and Easy DKIM tokens for one domain. |
| `ses-receipt-rule-set` | SES receipt rule set with opt-in active rule set ownership. |
| `ses-receipt-rule` | SES receipt rule with S3 raw-mail action and app-specific Lambda action. |
| `build-notifier` | Shared CodeBuild notification SNS topic, email subscription, and formatter Lambda. |
| `build-notifier-project-subscription` | App-owned EventBridge rule and Lambda permission that opts CodeBuild projects into the shared notifier. |

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

Phase 3 added AWS API domain building blocks:

- `acm-dns-validated-certificate`
- `api-gateway-custom-domain`

Phase 4 added Cloudflare DNS building blocks:

- `cloudflare-acm-validation-records` (consolidated into `cloudflare-dns-records` in Phase 7)
- `cloudflare-api-dns` (consolidated into `cloudflare-dns-records` in Phase 7)

Phase 5 added the first low-risk SES inbound primitives:

- `ses-domain-identity`
- `cloudflare-ses-domain-records` (consolidated into `cloudflare-dns-records` in Phase 7)
- `cloudflare-ses-inbound-mx` (consolidated into `cloudflare-dns-records` in Phase 7)

Phase 6 added SES receipt routing primitives:

- `ses-receipt-rule-set`
- `ses-receipt-rule`

Phase 7 collapsed the four single-resource Cloudflare DNS wrappers into one generic, records-as-data module (released as `1.7.0`):

- `cloudflare-dns-records`

The previous per-purpose Cloudflare DNS modules added a renamed variable shape over a single `cloudflare_dns_record` resource without combining anything, and they fragmented the module namespace. The consolidated module accepts a `records` map keyed by caller-chosen keys and lets consumers compose any SES-specific or purpose-specific names and contents at the call site.

Consumers of the four removed modules must update their `source` to `cloudflare-dns-records` and run the `moved` blocks documented in the [cloudflare-dns-records README](cloudflare-dns-records/README.md) before applying. Apply must show no create, update, delete, or replace for moved records.

`reference-architecture` is now the first full scaffold consumer of the current module set. It composes these modules into a runnable AWS + Cloudflare app scaffold while keeping application-specific configuration in the consuming repository.

AWS modules and Cloudflare modules remain separate provider boundaries. AWS modules own AWS primitives such as ECR, DynamoDB, IAM, CloudWatch, Cloud Map, ECS, API Gateway, and ACM. Cloudflare modules own Cloudflare DNS records only, and consuming apps connect the two through outputs and remote state.

App-specific config, secrets, domains, product logic, SES activation decisions, raw mail storage, forwarder Lambdas, mail provider records, Cloudflare security rules, tenant-specific routing, and other product infrastructure stay in consuming repos unless a focused reusable module is added later. Shared build notification infrastructure can be split between `build-notifier` in a shared platform repo and `build-notifier-project-subscription` in each app repo.

## Usage

Reference a module by repository URL, subfolder, and tag. The `?ref=<tag>` query pins the module to a specific Git tag from this repo so consumer plans are reproducible.

```hcl
module "dynamodb_single_table" {
  source = "github.com/jch254/terraform-modules//dynamodb-single-table?ref=1.7.0"

  name          = "reference-architecture-entities"
  hash_key      = "PK"
  range_key     = "SK"
  ttl_enabled   = true
  ttl_attribute = "expiresAt"
  tags          = local.tags
}
```

For modules used in deployed apps, always pin to a tag rather than a branch — branches move and a future apply can pick up unrelated changes:

```hcl
source = "github.com/jch254/terraform-modules//ecs-fargate-service?ref=1.7.0"
```

## Tags and versioning

This repo uses a single repo-wide tag stream (`1.0.0`, `1.1.0`, ..., `1.8.2`). Every module is versioned together — consuming apps use the same `?ref=<tag>` for every module they pull from this repo.

Versioning follows a pragmatic SemVer:

- **Patch** (`1.6.x` → `1.6.y`) — bug fixes, doc-only changes, and additive optional inputs that default to prior behaviour. Safe to bump consumer `?ref` without code changes.
- **Minor** (`1.x.0` → `1.y.0`) — new modules, new outputs, new optional inputs, or new resources where consumers can adopt with `moved` blocks and no resource churn (`Plan: 0 to add, 0 to change, 0 to destroy`). Module removals or renames also land here as long as the migration path is `moved`-only — see Phase 7 / `1.7.0` for an example.
- **Major** (`1.y.0` → `2.0.0`) — reserved for changes that consumers cannot migrate to without resource recreation, provider replacement, or unavoidable plan churn on long-lived infrastructure.

When a release reshapes a module path (rename, removal, or consolidation), the affected module's README documents the `moved` blocks or `terraform state mv` commands callers run alongside the `?ref` bump. Consumers must run those before `terraform apply`. See [Migration approach](#migration-approach) below.

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

Tags this repo has shipped. See [Tags and versioning](#tags-and-versioning) for what each level of bump means.

- `1.1.0`: current-gen low-risk modules, including ECR and DynamoDB, plus CodeBuild updates.
- `1.1.1`: CodeBuild log group management made optional for parity-safe migration.
- `1.2.0`: runtime-edge modules for ECS Fargate, Cloud Map, API Gateway, runtime IAM, security groups, and logs.
- `1.3.0`: AWS API domain modules for ACM DNS-validated certificates and API Gateway custom domains/mappings.
- `1.4.0`: Cloudflare DNS modules for ACM validation records and API CNAME records.
- `1.5.0`: SES inbound primitives — `ses-domain-identity`, `cloudflare-ses-domain-records`, `cloudflare-ses-inbound-mx`.
- `1.6.0`: SES receipt routing primitives — `ses-receipt-rule-set`, `ses-receipt-rule`.
- `1.7.0`: consolidated `cloudflare-dns-records` module replaces `cloudflare-acm-validation-records`, `cloudflare-api-dns`, `cloudflare-ses-domain-records`, and `cloudflare-ses-inbound-mx`. Migration is `moved`-block only — see the [cloudflare-dns-records README](cloudflare-dns-records/README.md) for the per-module `moved` targets and `terraform state mv` commands. Consumers must run the moves before `terraform apply` so the plan shows no record churn.
- `1.8.0`: `build-notifier` module for reusable CodeBuild success/failure email notifications.
- `1.8.1`: `build-notifier` can be deployed as shared core-only infrastructure, and `build-notifier-project-subscription` lets app repos own their EventBridge opt-in rules.
- `1.8.2`: `codebuild-project` declares its AWS provider requirement explicitly so provider alias passing validates without warnings.

## License

MIT
