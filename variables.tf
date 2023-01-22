variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "app_jwt_secret" {
  description = "The JWT secret of app"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "certificate_arn" {
  type        = string
  description = "certificate arn"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

# RDS
variable "rds_identifier" {
  type        = string
  description = "RDS instant identifier"
}

variable "rds_instance_class" {
  default     = "db.t3.micro"
  description = "The instance type"
}

variable "rds_allocated_storage" {
  default     = "20"
  description = "The storage size in GB"
}

variable "rds_multi_az" {
  default     = false
  description = "Muti-az allowed?"
}

variable "rds_database_name" {
  type        = string
  description = "The name of database"
}

variable "rds_database_username" {
  type        = string
  default     = "admin"
  description = "The username of the database"
}

variable "rds_database_password" {
  description = "The password of the database"
  type        = string
  sensitive   = true
}

# Codebuild API
variable "app_api_source_location" {
  description = "Location of the source code from git for API"
  type        = string
}

# Codebuild Web
variable "app_web_source_location" {
  description = "Location of the source code from git for Web"
  type        = string
}
variable "app_web_s3_bucket_name" {
  description = "S3 Bucket for IAM to access"
  type        = string
}
variable "app_web_distribution" {
  description = "distribution"
  type        = string
}
variable "app_web_distribution_arn" {
  description = "distribution arn"
  type        = string
}
variable "app_web_api_endpoint" {
  description = "endpoint of api"
  type        = string
}

# Route53
variable "route_zone_id" {
  type        = string
  description = "The ID of the hosted zone to contain this record"
}

variable "route_api_record_name" {
  type        = string
  description = "The name of the record for api sub domain"
}