# Elastic Container Repository

resource "aws_ecr_repository" "aws-ecr" {
  name = var.ecr_name
  tags = {
    Name        = var.tag_name
    Environment = var.tag_environment
  }
}