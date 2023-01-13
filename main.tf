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
  region  = "ap-southeast-1"
}

module "ecr" {
    source = "./modules/ecr"

    ecr_name = "${var.app_name}-${var.app_environment}"
    tag_name = "${var.app_name}-ecr"
    tag_environment = var.app_environment
}   

module "vpc" {
    source = "./modules/vpc"

    tag_name = "${var.app_name}-vpc"
    tag_environment = var.app_environment
}   

module "iam" {
    source = "./modules/iam"

    iam_name = "${var.app_name}-execution-task-role"
    tag_name = "${var.app_name}-iam-role"
    tag_environment = var.app_environment
}   

module "network" {
    source = "./modules/network"

    app_name = var.app_name
    app_environment = var.app_environment
    availability_zones = var.availability_zones
    public_subnets     = var.public_subnets
    private_subnets    = var.private_subnets

    vpc_id = module.vpc.vpc_id
}   

module "alb" {
    source = "./modules/alb"

    app_name = var.app_name
    app_environment = var.app_environment
    certificate_arn = var.certificate_arn

    vpc_id = module.vpc.vpc_id
    public_subnets = module.network.public_subnet_id
}   