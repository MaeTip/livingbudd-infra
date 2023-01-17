variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "Role for execution task definition"
}

variable "api_repository_url" {
  type        = string
  description = "The URL of the repository"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private Subnet IDs"
}

variable "load_balancer_security_group_id" {
  type        = string
  description = "Load balancer security group id"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "target_group_arn" {
  type        = string
  description = "AWS Target Group ARN"
}

