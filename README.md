# Terraform-modules

A good practice is to create a repository containing common infrastructure components which can be referenced and configured within other projects (e.g. web-app, rds-database, ecs-service etc.). Utilising Terraform modules to create 'building blocks' allows conventions to be enforced and standards defined for infrastructure (e.g. tags, security etc.). Modules are defined once then referenced and configured within projects using the repository URL/branch/tag/subfolder as the module source. This makes it easy for developers to define infrastructure as code within projects, achieve total ownership (provisioning and deploying as needed) and move fast. It also makes it easy to try out new concepts/ideas on isolated infrastructure. See [Standardizing Application Deployments Using Amazon ECS and Terraform](https://www.slideshare.net/AmazonWebServices/aws-reinvent-2016-gam401-riot-games-standardizing-application-deployments-using-amazon-ecs-and-terraform) for a more detailed introduction.

## Module Inventory

- `build-pipeline` - legacy CodePipeline and CodeBuild pipeline module for older GitHub OAuth based deployments.
- `codebuild-project` - standalone CodeBuild project module, extended for current ECS deployment pipelines.
- `dynamodb-single-table` - DynamoDB single-table module for current app data stores.
- `ecr-repository` - ECR repository module for current container image repositories.
- `lambda-function` - legacy Lambda packaging/deployment helper.
- `web-app` - legacy S3 and CloudFront static web app module.
- `web-app-redirect` - legacy S3 and CloudFront redirect module.

## Current App Stack Direction

The current app stack should be composed from small modules rather than a single app module. Phase 1 adds low-risk building blocks for ECR, DynamoDB, and CodeBuild. ECS Fargate, API Gateway HTTP API, Cloud Map, Cloudflare DNS, build notifications, and SES routing should remain separate future modules.

`web-app` and `web-app-redirect` remain intentionally legacy modules for older static-hosting projects and should not be overloaded with the ECS/API Gateway pattern.