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

# Elastic Container Repository
module "ecr" {
    source = "./modules/ecr"

    ecr_name = "${var.app_name}-${var.app_environment}-ecr"
    tag_name = "${var.app_name}-ecr"
    tag_environment = var.app_environment
}   

# resource "aws_instance" "app_server" {
#   ami           = "ami-830c94e3"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ExampleAppServerInstance"
#   }
# }