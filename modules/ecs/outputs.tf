output "cluster_name" {
  description = "The name of the created ECS cluster."
  value       = aws_ecs_cluster.aws-ecs-cluster.name
}

output "service_name" {
  description = "The name of the created ECS cluster service"
  value       = aws_ecs_service.aws-ecs-service.name
}
