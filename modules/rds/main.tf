# Relational Database Service

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.app_name}-${var.app_environment}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.app_name}-rds-subnet-group"
    Environment = "${var.app_environment}"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.app_name}-${var.app_environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${var.load_balancer_security_group_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-rds-sg"
    Environment = var.app_environment
  }
}

resource "aws_db_instance" "rds" {
  identifier             = var.identifier
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  multi_az               = var.multi_az
  db_name                = var.database_name
  username               = var.database_username
  password               = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }

  depends_on = [
    aws_security_group.rds_sg
  ]
}
