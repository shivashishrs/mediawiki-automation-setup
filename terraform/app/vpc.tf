data "aws_availability_zones" "available" {
}


module "vpc" {

  name = "${var.app_name}-${var.env}"
  cidr = "10.16.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.16.1.0/24", "10.16.2.0/24"]
  public_subnets       = ["10.16.101.0/24", "10.16.102.0/24", "10.16.103.0/24"]
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"
}