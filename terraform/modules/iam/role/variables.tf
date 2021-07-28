# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "project_name" {
  description = "The name to use of all cluster resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "env" {
  description = "Environment in which application is supposed to be deployed e.g dev/staging/prod"
  type = string
}


variable "assuming_role_service" {
  description = "Service that will assume this role e.g. ecs-tasks.amazonaws.com"
  type = string
}

//variable "role_policy_file" {
//  description = "Name of the file(without extension) where the role policy is mentioned e.g for role-policy.json values is role-policy"
//  type = string
//}

variable "role_name" {
  description = "IAM role name ( This will be used in creating the IAM role)"
}

variable "additional_permissions" {
  description = "Additional permissions for IAM role"
  type = list(any)
  default = []
}