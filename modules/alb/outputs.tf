output "load_balancer_security_group_id" {
  description = "Load balancer security group id"
  value = aws_security_group.load_balancer_security_group.id
}

output "target_group_arn" {
  description = "Load balancer security group id"
  value = aws_lb_target_group.target_group.arn
}

