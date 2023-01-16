variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "cluster_name" {
  type        = string
  description = "ECS Cluster Name"
}

variable "service_name" {
  type        = string
  description = "ECS Service Name"
}
