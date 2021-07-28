variable "aws_vpc_name" {
  description = "Name of the vpc"
  type = string
}

variable "team" {
  description = "Which team is creating this VPC"
  type = string
}

variable "product" {
  description = "Name of the product"
  type = string
}

variable "environment" {
  description = "VPC environment e.g. Dev/QA/Stage/Prod"
  type = string
}

variable "number_of_public_subnet" {
  description = ""
  type = number
}

variable "aws_vpc_cidr" {
  description = "CIDR range for VPC default 10.16.0.0/16"
  default = "10.16.0.0/16"
}