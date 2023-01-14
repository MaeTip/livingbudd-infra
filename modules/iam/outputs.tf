output "iam_ecs_task_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.ecsTaskExecutionRole.arn
}