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

resource "aws_ssm_parameter" "app_smtp_username" {
  name  = "${var.app_name}_app_smtp_username"
  type  = "String"
  value = var.app_smtp_username

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "app_smtp_password" {
  name  = "${var.app_name}_app_smtp_password"
  type  = "SecureString"
  value = var.app_smtp_password

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "app_smtp_default_receiver" {
  name  = "${var.app_name}_app_smtp_default_receiver"
  type  = "String"
  value = var.app_smtp_default_receiver

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_ssm_parameter" "app_smtp_default_sender" {
  name  = "${var.app_name}_app_smtp_default_sender"
  type  = "String"
  value = var.app_smtp_default_sender

  tags = {
    Name        = "${var.app_name}-ssm"
    Environment = var.app_environment
  }
}

resource "aws_iam_role_policy" "role_policy" {
  role = var.iam_role_name
  name = "${var.app_name}-ssm-access"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Resource" : [
            "${aws_ssm_parameter.db_host.*.arn[0]}",
            "${aws_ssm_parameter.db_username.*.arn[0]}",
            "${aws_ssm_parameter.db_password.*.arn[0]}",
            "${aws_ssm_parameter.db_name.*.arn[0]}",
            "${aws_ssm_parameter.app_jwt_secret.*.arn[0]}",
            "${aws_ssm_parameter.app_smtp_username.*.arn[0]}",
            "${aws_ssm_parameter.app_smtp_password.*.arn[0]}",
            "${aws_ssm_parameter.app_smtp_default_receiver.*.arn[0]}",
            "${aws_ssm_parameter.app_smtp_default_sender.*.arn[0]}"
          ]
          "Action" : [
            "ssm:GetParameters"
          ],
        }
      ]
    }
  )
}
