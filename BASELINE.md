# Terraform Modules Baseline

Baseline documented on 2026-04-25 before phase 1 module updates.

At this point the module library contains these existing module paths:

- `build-pipeline` - legacy CodePipeline and CodeBuild pipeline module for older GitHub OAuth based deployments.
- `codebuild-project` - standalone CodeBuild project module.
- `lambda-function` - Lambda packaging/deployment helper with optional scheduled execution.
- `web-app` - legacy S3 and CloudFront static web app module.
- `web-app-redirect` - legacy S3 and CloudFront redirect module.

Phase 1 keeps the legacy static web modules for older projects, adds low-risk current-generation modules, and extends `codebuild-project` without changing its default behavior.