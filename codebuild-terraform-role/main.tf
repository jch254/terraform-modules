locals {
  role_name   = coalesce(var.role_name, "${var.name}-codebuild")
  policy_name = coalesce(var.policy_name, "${var.name}-codebuild-policy")

  tags = merge(
    {
      Name        = local.role_name
      Environment = var.environment
    },
    var.tags,
  )

  logs_statements = length(var.cloudwatch_logs_actions) == 0 ? [] : [
    {
      Effect   = "Allow"
      Action   = var.cloudwatch_logs_actions
      Resource = ["*"]
    }
  ]

  s3_read_write_statements = length(var.s3_read_write_resource_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:GetBucketLocation",
        "s3:ListBucket",
      ]
      Resource = var.s3_read_write_resource_arns
    }
  ]

  s3_bucket_statements = length(var.s3_bucket_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "s3:GetBucketLocation",
        "s3:ListBucket",
      ]
      Resource = var.s3_bucket_arns
    }
  ]

  s3_object_statements = length(var.s3_object_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
      ]
      Resource = var.s3_object_arns
    }
  ]

  ecr_statements = length(var.ecr_repository_arns) == 0 ? [] : [
    {
      Effect   = "Allow"
      Action   = ["ecr:GetAuthorizationToken"]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:CreateRepository",
        "ecr:DeleteRepository",
        "ecr:DescribeRepositories",
        "ecr:ListTagsForResource",
        "ecr:TagResource",
        "ecr:UntagResource",
        "ecr:PutImageScanningConfiguration",
        "ecr:PutImageTagMutability",
      ]
      Resource = var.ecr_repository_arns
    }
  ]

  ecs_statements = var.enable_ecs ? [
    {
      Effect = "Allow"
      Action = [
        "ecs:CreateCluster",
        "ecs:DeleteCluster",
        "ecs:DescribeClusters",
        "ecs:CreateService",
        "ecs:UpdateService",
        "ecs:DeleteService",
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:RegisterTaskDefinition",
        "ecs:DeregisterTaskDefinition",
        "ecs:ListTagsForResource",
        "ecs:TagResource",
        "ecs:UntagResource",
      ]
      Resource = ["*"]
    }
  ] : []

  ec2_networking_statements = var.enable_ec2_networking ? [
    {
      Effect = "Allow"
      Action = [
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSecurityGroupRules",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:CreateTags",
        "ec2:DeleteTags",
      ]
      Resource = ["*"]
    }
  ] : []

  api_gateway_statements = var.enable_api_gateway ? [
    {
      Effect = "Allow"
      Action = [
        "apigateway:GET",
        "apigateway:POST",
        "apigateway:PUT",
        "apigateway:PATCH",
        "apigateway:DELETE",
        "apigateway:TagResource",
        "apigateway:UntagResource",
      ]
      Resource = var.api_gateway_resource_arns
    }
  ] : []

  service_discovery_statements = var.enable_service_discovery ? [
    {
      Effect = "Allow"
      Action = [
        "servicediscovery:CreatePrivateDnsNamespace",
        "servicediscovery:DeleteNamespace",
        "servicediscovery:GetNamespace",
        "servicediscovery:ListNamespaces",
        "servicediscovery:CreateService",
        "servicediscovery:DeleteService",
        "servicediscovery:GetService",
        "servicediscovery:UpdateService",
        "servicediscovery:GetOperation",
        "servicediscovery:ListTagsForResource",
        "servicediscovery:TagResource",
        "servicediscovery:UntagResource",
      ]
      Resource = ["*"]
    }
  ] : []

  route53_statements = var.enable_route53 ? [
    {
      Effect = "Allow"
      Action = [
        "route53:CreateHostedZone",
        "route53:DeleteHostedZone",
        "route53:GetHostedZone",
        "route53:ListHostedZones",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:GetChange",
      ]
      Resource = ["*"]
    }
  ] : []

  iam_statements = length(var.iam_role_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:UpdateRole",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:GetRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PassRole",
        "iam:ListInstanceProfilesForRole",
        "iam:TagRole",
        "iam:UntagRole",
      ]
      Resource = var.iam_role_arns
    }
  ]

  sts_statements = [
    {
      Effect   = "Allow"
      Action   = ["sts:GetCallerIdentity"]
      Resource = ["*"]
    }
  ]

  codebuild_statements = length(var.codebuild_project_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "codebuild:CreateProject",
        "codebuild:DeleteProject",
        "codebuild:UpdateProject",
        "codebuild:BatchGetProjects",
        "codebuild:CreateWebhook",
        "codebuild:DeleteWebhook",
        "codebuild:UpdateWebhook",
      ]
      Resource = var.codebuild_project_arns
    }
  ]

  ssm_statements = length(var.ssm_parameter_arns) == 0 ? [] : [
    {
      Effect   = "Allow"
      Action   = ["ssm:DescribeParameters"]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:PutParameter",
        "ssm:DeleteParameter",
        "ssm:AddTagsToResource",
        "ssm:RemoveTagsFromResource",
        "ssm:ListTagsForResource",
      ]
      Resource = var.ssm_parameter_arns
    }
  ]

  secretsmanager_statements = length(var.secretsmanager_secret_arns) == 0 ? [] : [
    {
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = var.secretsmanager_secret_arns
    }
  ]

  dynamodb_statements = length(var.dynamodb_table_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "dynamodb:CreateTable",
        "dynamodb:DeleteTable",
        "dynamodb:DescribeTable",
        "dynamodb:DescribeTimeToLive",
        "dynamodb:UpdateTimeToLive",
        "dynamodb:DescribeContinuousBackups",
        "dynamodb:ListTagsOfResource",
        "dynamodb:TagResource",
        "dynamodb:UntagResource",
      ]
      Resource = var.dynamodb_table_arns
    }
  ]

  ses_statements = var.enable_ses ? [
    {
      Effect = "Allow"
      Action = [
        "ses:CreateReceiptRuleSet",
        "ses:DeleteReceiptRuleSet",
        "ses:DescribeReceiptRuleSet",
        "ses:ListReceiptRuleSets",
        "ses:DescribeActiveReceiptRuleSet",
        "ses:CreateReceiptRule",
        "ses:DeleteReceiptRule",
        "ses:DescribeReceiptRule",
        "ses:UpdateReceiptRule",
        "ses:VerifyDomainIdentity",
        "ses:GetIdentityVerificationAttributes",
        "ses:DeleteIdentity",
        "ses:VerifyDomainDkim",
        "ses:GetIdentityDkimAttributes",
        "ses:SetIdentityDkimEnabled",
      ]
      Resource = var.ses_resource_arns
    }
  ] : []

  sns_statements = length(var.sns_topic_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "sns:CreateTopic",
        "sns:DeleteTopic",
        "sns:GetTopicAttributes",
        "sns:SetTopicAttributes",
        "sns:Subscribe",
        "sns:Unsubscribe",
        "sns:GetSubscriptionAttributes",
        "sns:ListSubscriptionsByTopic",
        "sns:ListTagsForResource",
        "sns:TagResource",
        "sns:UntagResource",
      ]
      Resource = var.sns_topic_arns
    }
  ]

  eventbridge_statements = length(var.event_rule_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "events:PutRule",
        "events:DeleteRule",
        "events:DescribeRule",
        "events:PutTargets",
        "events:RemoveTargets",
        "events:ListTargetsByRule",
        "events:ListTagsForResource",
        "events:TagResource",
        "events:UntagResource",
      ]
      Resource = var.event_rule_arns
    }
  ]

  lambda_statements = length(var.lambda_function_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "lambda:CreateFunction",
        "lambda:DeleteFunction",
        "lambda:GetFunction",
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration",
        "lambda:GetFunctionConfiguration",
        "lambda:AddPermission",
        "lambda:RemovePermission",
        "lambda:GetPolicy",
        "lambda:ListVersionsByFunction",
        "lambda:TagResource",
        "lambda:UntagResource",
        "lambda:ListTags",
      ]
      Resource = var.lambda_function_arns
    }
  ]

  lambda_permission_statements = length(var.lambda_permission_function_arns) == 0 ? [] : [
    {
      Effect = "Allow"
      Action = [
        "lambda:AddPermission",
        "lambda:RemovePermission",
        "lambda:GetPolicy",
      ]
      Resource = var.lambda_permission_function_arns
    }
  ]

  policy_statements = concat(
    local.logs_statements,
    local.s3_read_write_statements,
    local.s3_bucket_statements,
    local.s3_object_statements,
    local.ecr_statements,
    local.ecs_statements,
    local.ec2_networking_statements,
    local.api_gateway_statements,
    local.service_discovery_statements,
    local.route53_statements,
    local.iam_statements,
    local.sts_statements,
    local.codebuild_statements,
    local.ssm_statements,
    local.secretsmanager_statements,
    local.dynamodb_statements,
    local.ses_statements,
    local.sns_statements,
    local.eventbridge_statements,
    local.lambda_statements,
    local.lambda_permission_statements,
    var.additional_policy_statements,
  )
}

resource "aws_iam_role" "this" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy" "this" {
  name = local.policy_name
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.policy_statements
  })
}
