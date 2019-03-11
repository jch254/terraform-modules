# Codebuild-project

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| build_compute_type | CodeBuild compute type (e.g. BUILD_GENERAL1_SMALL) | string | `BUILD_GENERAL1_SMALL` | no |
| build_docker_image | Docker image to use as build environment | string | - | yes |
| build_docker_tag | Docker image tag to use as build environment | string | - | yes |
| buildspec | The CodeBuild build spec declaration path - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html | string | - | yes |
| codebuild_role_arn | ARN of IAM role that allows CodeBuild to interact with dependent AWS services | string | - | yes |
| log_retention | Specifies the number of days to retain build log events | string | `7` | no |
| name | Name of project (used in AWS resource names) | string | - | yes |
| privileged_mode | If set to true, enables running the Docker daemon inside a Docker container | string | `false` | no |
| source_location | HTTPS URL of CodeCommit repo or S3 bucket to use as project source | string | - | yes |
| source_type | Type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB or S3. | string | - | yes |
