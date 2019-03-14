# Codebuild-project

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| build\_compute\_type | CodeBuild compute type (e.g. BUILD_GENERAL1_SMALL) | string | `"BUILD_GENERAL1_SMALL"` | no |
| build\_docker\_image | Docker image to use as build environment | string | n/a | yes |
| build\_docker\_tag | Docker image tag to use as build environment | string | n/a | yes |
| buildspec | The CodeBuild build spec declaration path - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html | string | n/a | yes |
| cache\_bucket | S3 bucket to use as build cache, the value must be a valid S3 bucket name/prefix | string | `""` | no |
| codebuild\_role\_arn | ARN of IAM role that allows CodeBuild to interact with dependent AWS services | string | n/a | yes |
| log\_retention | Specifies the number of days to retain build log events | string | `"7"` | no |
| name | Name of project (used in AWS resource names) | string | n/a | yes |
| privileged\_mode | If set to true, enables running the Docker daemon inside a Docker container | string | `"false"` | no |
| source\_location | HTTPS URL of CodeCommit repo or S3 bucket to use as project source | string | n/a | yes |
| source\_type | Type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB or S3. | string | n/a | yes |