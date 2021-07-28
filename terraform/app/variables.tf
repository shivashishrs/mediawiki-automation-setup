variable "application_port" {
  description = "Port on which application is running"
  default     = 80
}

variable "app_name" {
  description = "Name of the application"
  default     = "mediawiki"
}

variable "env" {
  description = "Environment of the app e.g. prod/stage/dev"
  default     = "demo"
}

variable "codepipeline_source_s3_bucket" {
  description = "Name of the s3 bucket where code is hosted"
  default     = "mediawiki-demo1"
}

variable "ssh_user" {
  description = "Default ssh user"
  default     = "ec2-user"
}

variable "key_path" {
  description = "Key path of private file to connect to server"
  default     = "~/.ssh/mediwikikey.pem"
}

variable "ami" {
  description = "AMI id to use in EC2 instance"
  default     = "ami-0e75020b7da68d0d4"
}

variable "admin_username" {
  description = "Admin username for the mediawiki site"
  default     = "Admin"
}

variable "admin_password" {
  description = "Admin password for the mediawiki site"
  default     = "Mediawiki@12345"
}