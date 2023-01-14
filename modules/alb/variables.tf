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

variable "certificate_arn" {
  type = string
  description = "Certificate ARN"
}

variable "public_subnets_ids" {
  type        =  list(string)
  description = "Public Subnet IDs"
}
