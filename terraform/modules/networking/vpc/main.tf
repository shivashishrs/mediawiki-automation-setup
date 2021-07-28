
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "vcs_vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name          = var.aws_vpc_name
    Product       = var.product
    Team          = var.team
    Environment   = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.number_of_public_subnet
  vpc_id     = aws_vpc.vcs_vpc.id
  cidr_block = cidrsubnet(aws_vpc.vcs_vpc.cidr_block, 8, 2)
  tags = {
    Name          = "subnet-${var.option_3_aws_vpc_name}"
    Product       = var.product
    Team          = var.team
    Owner         = var.owner
    Environment   = var.environment
    Organization  = var.organization
    "Cost Center" = var.costcenter
  }
}

