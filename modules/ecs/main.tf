# Elastic Container Service Cluster and Tasks Configuration

resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.app_name}-${var.app_environment}-cluster"
  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.app_environment
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.app_name}-${var.app_environment}-logs"

  tags = {
    Application = var.app_name
    Environment = var.app_environment
  }
}

data "template_file" "env_vars" {
  template = file("${path.module}/env_vars.json")
}

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"

  container_definitions = jsonencode(
    [
      {
        "name" : "${var.app_name}-${var.app_environment}-container",
        "image" : "${var.repository_url}:latest",
        "entryPoint" : [],
        "environment" : [
          { "name" : "environment", "value" : "${data.template_file.env_vars.rendered}" }
        ],
        "essential" : true,
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "${aws_cloudwatch_log_group.log-group.id}",
            "awslogs-region" : "${var.aws_region}",
            "awslogs-stream-prefix" : "${var.app_name}-${var.app_environment}"
          }
        },
        "portMappings" : [
          {
            "containerPort" : 8080,
            "hostPort" : 8080
          }
        ],
        "cpu" : 256,
        "memory" : 512,
        "networkMode" : "awsvpc"
      }
    ]
  )

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = var.ecs_task_role_arn
  task_role_arn            = var.ecs_task_role_arn

  tags = {
    Name        = "${var.app_name}-ecs-td"
    Environment = var.app_environment
  }

  depends_on = [aws_cloudwatch_log_group.log-group]
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_name}-${var.app_environment}-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = "${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups = [
      aws_security_group.service_security_group.id,
      var.load_balancer_security_group_id
    ]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.app_name}-${var.app_environment}-container"
    container_port   = 8080
  }
}

resource "aws_security_group" "service_security_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.load_balancer_security_group_id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-service-sg"
    Environment = var.app_environment
  }
}
