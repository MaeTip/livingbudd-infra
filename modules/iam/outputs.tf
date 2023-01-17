output "iam_ecs_task_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.ecsTaskExecutionRole.arn
}

output "iam_ecs_task_role_name" {
  description = "The name of the role."
  value       = element(concat(aws_iam_role.ecsTaskExecutionRole.*.name, [""]), 0)
}
