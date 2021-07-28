variable "db_storage" {
  description = "Storage size of the database default 10 GB"
  default = 10
}

variable "app_name" {
  description = "Name of the application"
}

variable "env" {
  description = "Environment of the app e.g. prod/stage/dev"
}

variable "db_username" {
  description = "Admin username for the database"
}

variable "db_password" {
  description = "Admin password for the database"
}

variable "db_name" {
  description = "Database name"
}


variable "db_engine" {
  description = "Database Engine default mysql"
  default = "mysql"
  type = string
}

variable "db_engine_version" {
  description = "Database Engine version Default: 5.7"
  default = 5.7
  type = number
}

variable "db_instance_class" {
  description = "Instance type of the db Default: db.t3.small"
  default = "db.t3.small"
  type = string
}

variable "db_security_group_id" {
  description = "Security group ID for database"
  type = string
}

variable "db_subnet_ids" {
  description = "List of db subnet"
  type = list(string)
}