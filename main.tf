terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

module "ecr_api" {
  source = "./modules/ecr"

  ecr_name        = "${var.app_name}-api"
  tag_name        = "${var.app_name}-ecr-api"
  tag_environment = var.app_environment
}

module "vpc" {
  source = "./modules/vpc"

  tag_name        = "${var.app_name}-vpc"
  tag_environment = var.app_environment
}

module "iam" {
  source = "./modules/iam"

  iam_name        = "${var.app_name}-execution-task-role"
  tag_name        = "${var.app_name}-iam-role"
  tag_environment = var.app_environment
}

module "network" {
  source = "./modules/network"

  app_name           = var.app_name
  app_environment    = var.app_environment
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"

  app_name        = var.app_name
  app_environment = var.app_environment
  certificate_arn = var.certificate_arn

  vpc_id             = module.vpc.vpc_id
  public_subnets_ids = module.network.public_subnet_ids
}

module "ecs" {
  source = "./modules/ecs"

  app_name        = var.app_name
  app_environment = var.app_environment
  aws_region      = var.aws_region

  vpc_id                          = module.vpc.vpc_id
  api_repository_url              = module.ecr_api.repository_url
  ecs_task_role_arn               = module.iam.iam_ecs_task_role_arn
  public_subnet_ids               = module.network.public_subnet_ids
  load_balancer_security_group_id = module.alb.load_balancer_security_group_id
  target_group_arn                = module.alb.target_group_arn

  depends_on = [
    module.alb,
    module.ecr_api
  ]
}

module "autoscaling" {
  source = "./modules/autoscaling"

  app_name        = var.app_name
  app_environment = var.app_environment

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}

module "rds" {
  source = "./modules/rds"

  app_name        = var.app_name
  app_environment = var.app_environment

  vpc_id                          = module.vpc.vpc_id
  public_subnet_ids               = module.network.public_subnet_ids
  load_balancer_security_group_id = module.alb.load_balancer_security_group_id

  allocated_storage = var.rds_allocated_storage
  instance_class    = var.rds_instance_class
  multi_az          = var.rds_multi_az
  identifier        = var.rds_identifier
  database_name     = var.rds_database_name
  database_username = var.rds_database_username
  database_password = var.rds_database_password

  depends_on = [
    module.alb
  ]
}

module "codebuild_api" {
  source = "./modules/codebuild"

  app_name        = var.app_name
  app_environment = var.app_environment

  iam_role_name   = "${var.app_name}-api-build-role"
  project_name    = "${var.app_name}-api-build-${var.app_environment}"
  build_timeout   = "20"
  source_location = var.app_api_source_location
}

module "codebuild_web" {
  source = "./modules/codebuild"

  app_name        = var.app_name
  app_environment = var.app_environment

  iam_role_name       = "${var.app_name}-web-build-role"
  project_name        = "${var.app_name}-web-build-${var.app_environment}"
  build_timeout       = "20"
  source_location     = var.app_web_source_location
  is_access_s3_bucket = true
  s3_bucket_name      = var.app_web_s3_bucket_name
  distribution_arn    = var.app_web_distribution_arn

  env_vars = {
    DISTRIBUTION_ID        = var.app_web_distribution
    BUCKET_NAME            = var.app_web_s3_bucket_name
    REACT_APP_API_ENDPOINT = var.app_web_api_endpoint
  }
}

module "ssm" {
  source = "./modules/ssm"

  app_name        = var.app_name
  app_environment = var.app_environment

  database_host = module.rds.rds_endpoint
  iam_role_name = module.iam.iam_ecs_task_role_name

  database_name     = var.rds_database_name
  database_username = var.rds_database_username
  database_password = var.rds_database_password
  app_jwt_secret    = var.app_jwt_secret

  app_smtp_username = var.app_api_smtp_username
  app_smtp_password = var.app_api_smtp_password
  app_smtp_default_receiver = var.app_api_smtp_default_receiver
  app_smtp_default_sender = var.app_api_smtp_default_sender

  depends_on = [
    module.rds,
    module.iam
  ]
}

module "route53" {
  source = "./modules/route53"

  zone_id     = var.route_zone_id
  record_name = var.route_api_record_name

  records = [module.alb.load_balancer_dns_name]
}

