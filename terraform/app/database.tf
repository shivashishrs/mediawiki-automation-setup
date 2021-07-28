module "db" {
  source               = "../modules/datastore/rds"
  app_name             = var.app_name
  db_username          = var.app_name
  env                  = var.env
  db_security_group_id = aws_security_group.db.id
  db_subnet_ids        = module.vpc.private_subnets
  db_password = random_password.db_pass.result
  db_name = "${ var.app_name }db"
}

resource "random_password" "db_pass" {
  length            = 20
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}

resource "aws_ssm_parameter" "db_pass" {
  name = "/mediawiki/${ var.env }/db/password"
  type = "SecureString"
  value = random_password.db_pass.result
}

resource "aws_ssm_parameter" "db_username" {
  name = "/mediawiki/${ var.env }/db/username"
  type = "String"
  value = var.app_name
}

resource "aws_ssm_parameter" "db_name" {
  name = "/mediawiki/${ var.env }/db/dbname"
  type = "String"
  value = var.app_name
}

resource "aws_ssm_parameter" "db_host" {
  name = "/mediawiki/${ var.env }/db/dbhost"
  type = "SecureString"
  value = module.db.db_endpoint
}

resource "aws_security_group" "db" {
  name   = "${var.app_name}-${var.env}-db-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [module.asg.instance_sg, aws_security_group.jb-sg.id]
  }
}