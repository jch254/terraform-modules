# Build-pipeline

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| approval_comment | Comment to include in approval notifications. Required if require_approval is true. | string | `A production deploy has been requested.` | no |
| approval_sns_topic_arn | Approval notifications will be published to the specified SNS topic. Required if require_approval is true. | string | `` | no |
| artifact_store_s3_bucket | S3 bucket where CodePipeline stores source artifacts, if not provided an S3 bucket will be created | string | `` | no |
| build_compute_type | CodeBuild compute type (e.g. BUILD_GENERAL1_SMALL) | string | `BUILD_GENERAL1_SMALL` | no |
| build_docker_image | Docker image to use as build environment | string | - | yes |
| build_docker_tag | Docker image tag to use as build environment | string | - | yes |
| buildspec | The CodeBuild build spec declaration expressed as a single string - see https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html | string | - | yes |
| codebuild_role_arn | ARN of IAM role that allows CodeBuild to interact with dependent AWS services | string | - | yes |
| codepipeline_role_arn | ARN of IAM role that allows CodePipeline to interact with dependent AWS services | string | - | yes |
| github_branch_name | GitHub repository branch to use as CodePipeline source | string | - | yes |
| github_oauth_token | OAuth token used to authenticate against CodePipeline source GitHub repository | string | - | yes |
| github_repository_name | Name of GitHub repository to use as CodePipeline source | string | - | yes |
| github_repository_owner | Owner of GitHub repository to use as CodePipeline source | string | - | yes |
| log_retention | Specifies the number of days to retain build log events | string | `90` | no |
| name | Name of project (used in AWS resource names) | string | - | yes |
| privileged_mode | If set to true, enables running the Docker daemon inside a Docker container | string | `false` | no |
| require_approval | Does the pipeline require approval to run? | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| artifacts_bucket_id |  |

