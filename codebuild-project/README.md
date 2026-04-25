# CodeBuild Project

Creates a standalone CodeBuild project. Defaults preserve the original module behavior. Optional inputs support the current reference architecture pattern: privileged Docker builds, plaintext environment variables for ECR/ECS deployment, shallow GitHub checkout, tags, and a push webhook.

## Legacy Example

```hcl
module "codebuild" {
	source = "git::https://github.com/jch254/terraform-modules.git//codebuild-project?ref=v0.2.0"

	name                = var.name
	codebuild_role_arn  = aws_iam_role.codebuild_role.arn
	build_docker_image  = var.build_docker_image
	build_docker_tag    = var.build_docker_tag
	source_type         = var.source_type
	source_location     = var.source_location
	buildspec           = var.buildspec
}
```

## Reference Architecture Example

```hcl
module "codebuild" {
	source = "git::https://github.com/jch254/terraform-modules.git//codebuild-project?ref=v0.2.0"

	name                         = var.name
	description                  = "Build project for ${var.name}"
	codebuild_role_arn           = aws_iam_role.codebuild_role.arn
	build_compute_type           = var.build_compute_type
	build_docker_image           = var.build_docker_image
	build_docker_tag             = var.build_docker_tag
	image_pull_credentials_type  = "CODEBUILD"
	privileged_mode              = true
	source_type                  = var.source_type
	source_location              = var.source_location
	buildspec                    = var.buildspec
	git_clone_depth              = 1
	cache_bucket                 = var.cache_bucket
	webhook_enabled              = true

	environment_variables = [
		{ name = "AWS_DEFAULT_REGION", value = var.region },
		{ name = "AWS_ACCOUNT_ID", value = data.aws_caller_identity.current.account_id },
		{ name = "IMAGE_REPO_NAME", value = module.ecr.repository_name },
		{ name = "IMAGE_TAG", value = var.image_tag },
		{ name = "CLUSTER_NAME", value = aws_ecs_cluster.main.name },
		{ name = "SERVICE_NAME", value = aws_ecs_service.main.name },
		{ name = "CLOUDFLARE_DOMAIN", value = var.cloudflare_domain },
		{ name = "CLOUDFLARE_SUBDOMAIN", value = var.cloudflare_subdomain },
	]

	tags = {
		Name        = "${var.name}-codebuild"
		Environment = var.environment
	}
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| badge\_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge_url output when true. | bool | `true` | no |
| build\_compute\_type | CodeBuild compute type (e.g. BUILD_GENERAL1_SMALL) | string | `"BUILD_GENERAL1_SMALL"` | no |
| build\_docker\_image | Docker image to use as build environment | string | n/a | yes |
| build\_docker\_tag | Docker image tag to use as build environment | string | n/a | yes |
| buildspec | The CodeBuild build spec declaration path - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html | string | n/a | yes |
| cache\_bucket | S3 bucket to use as build cache, the value must be a valid S3 bucket name/prefix | string | `""` | no |
| codebuild\_role\_arn | ARN of IAM role that allows CodeBuild to interact with dependent AWS services | string | n/a | yes |
| description | Description for the CodeBuild project. Defaults to the legacy module description when empty. | string | `""` | no |
| environment\_variables | Environment variables for the build environment. Each item supports name, value, and optional type. | list(map(string)) | `[]` | no |
| git\_clone\_depth | Optional git clone depth for source checkout. | number | `null` | no |
| image\_pull\_credentials\_type | Type of credentials CodeBuild uses to pull the build image. Leave empty to use the AWS provider default. | string | `""` | no |
| log\_retention | Specifies the number of days to retain build log events | string | `"7"` | no |
| name | Name of project (used in AWS resource names) | string | n/a | yes |
| privileged\_mode | If set to true, enables running the Docker daemon inside a Docker container | string | `"false"` | no |
| source\_location | HTTPS URL of CodeCommit repo or S3 bucket to use as project source | string | n/a | yes |
| source\_type | Type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB or S3. | string | n/a | yes |
| tags | Tags to apply to CodeBuild resources. | map(string) | `{}` | no |
| webhook\_build\_type | Webhook build type. | string | `"BUILD"` | no |
| webhook\_enabled | Whether to create a CodeBuild webhook for the project. | bool | `false` | no |
| webhook\_filter\_groups | Webhook filter groups. Defaults to push events on refs/heads/main when webhook_enabled is true and no filters are provided. | list(list(map(string))) | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| badge\_url |  |
| project\_name | CodeBuild project name. |
| project\_arn | CodeBuild project ARN. |
| project\_id | CodeBuild project ID. |