resource "aws_ssm_parameter" "db_host" {
  name  = "${var.app_name}_db_host"
  type  = "String"
  value = var.database_host

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "db_username" {
  name  = "${var.app_name}_db_username"
  type  = "String"
  value = var.database_username

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "${var.app_name}_db_password"
  type  = "SecureString"
  value = var.database_password

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "db_name" {
  name  = "${var.app_name}_db_name"
  type  = "String"
  value = var.database_name

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "app_jwt_secret" {
  name  = "${var.app_name}_app_jwt_secret"
  type  = "String"
  value = var.app_jwt_secret

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}
