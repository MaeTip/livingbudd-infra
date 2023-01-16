variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for RDS instance"
}

variable "load_balancer_security_group_id" {
  type        = string
  description = "Load balancer security group id"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "identifier" {
  type        = string
  description = "RDS instant identifier"
}

variable "allocated_storage" {
  type        = string
  default     = "20"
  description = "The storage size in GB"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance type"
}

variable "multi_az" {
  default     = false
  description = "Muti-az allowed?"
}

variable "database_name" {
  type        = string
  description = "The database name"
}

variable "database_username" {
  type        = string
  default     = "admin"
  description = "The username of the database"
}

variable "database_password" {
  description = "The password of the database"
  type        = string
  sensitive   = true
}

