app_name        = "living-budd"
app_environment = "production"
aws_region      = "ap-southeast-1"

availability_zones = ["ap-southeast-1b", "ap-southeast-1c"]
public_subnets     = ["10.10.100.0/24", "10.10.101.0/24"]
private_subnets    = ["10.10.0.0/24", "10.10.1.0/24"]

certificate_arn = "arn:aws:acm:ap-southeast-1:312726873549:certificate/a1132ca4-7921-4e4f-b769-ed99f91de04b"
