
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "project_name" {
  description = "The name to use of all cluster resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
}

variable "ami_id" {
  description = "EC2 instance AMI ID respective to the region"
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type = number
}

variable "subnet_ids" {
  description = "The Subnet IDs  autoscaling to deploy to"
  type = list(string)
}

variable "user_data" {
  description = "User data script for instance"
  type = string
}


variable "vpc_id" {
  description = "VPC ID for the load balancer"
  type = string
}

variable "key_pair" {
  description = "Key pair name for the instance"
  type = string
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_type" {
  description = "The type of EC2 instance to be run (e.g. t2.micro)"
  type = string
  default = "t2.micro"
}

variable "target_group_arns" {
  description = "ARN of the load balancer target group in which to register instances"
  type = list(string)
  default = []
}

variable "health_check_type" {
  description = "ASG health check type {default: EC2}"
  type = string
  default = "EC2"
}
variable "server_port" {
  description = "Instance port on which application will listen { default : 80 }"
  type = number
  default = 80
}

variable "additional_permissions" {
  description = "Additional permissions for IAM role"
  type = list(string)
  default = []
}