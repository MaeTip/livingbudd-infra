variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "iam_role_name" {
  type        = string
  description = "Name of IAM role to build package"
}

variable "project_name" {
  type        = string
  description = "Name of codebuild project"
}

variable "build_timeout" {
  type        = string
  description = "Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out"
}

variable "source_location" {
  type        = string
  description = "Location of the source code from git"
}
