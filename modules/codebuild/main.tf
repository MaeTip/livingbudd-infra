# Codebuild

resource "aws_iam_role" "iam_role" {
  name = var.iam_role_name

  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ecr" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "policy_attachment_ecs" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy" "role_policy" {
  role = aws_iam_role.iam_role.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "role_s3_access_policy" {
  count = var.is_access_s3_bucket ? 1 : 0
  role = aws_iam_role.iam_role.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action": "*",
          "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation"
            ],
            "Resource": var.distribution_arn
        }
      ]
    }
  )
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = var.project_name
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.iam_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    dynamic "environment_variable" {
      for_each = var.env_vars
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "GITHUB"
    location        = var.source_location
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "refs/heads/develop"

  tags = {
    Name        = "${var.app_name}-codebuild"
    Environment = var.app_environment
  }
}

resource "aws_codebuild_webhook" "codebuild_webhook" {
  project_name = aws_codebuild_project.codebuild_project.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "develop"
    }
  }
}
