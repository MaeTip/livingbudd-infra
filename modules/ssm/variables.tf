variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "database_host" {
  type        = string
  description = "The host of database"
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

variable "app_jwt_secret" {
  description = "The JWT secret of app"
  type        = string
  sensitive   = true
}

variable "iam_role_name" {
  description = "IAM role to access SSM parameter"
  type        = string
}

variable "app_smtp_username" {
  description = "smtp username"
  type        = string
  sensitive   = true
}

variable "app_smtp_password" {
  description = "smtp password"
  type        = string
  sensitive   = true
}

variable "app_smtp_default_receiver" {
  description = "SMTP default receivers"
  type        = string
}

variable "app_smtp_default_sender" {
  description = "SMTP default sender"
  type        = string
}
