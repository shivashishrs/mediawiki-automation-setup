
resource "aws_db_instance" "default" {
  identifier = "${ var.app_name }${ var.env }db"
  allocated_storage    = var.db_storage
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.${ var.db_engine }${ var.db_engine_version }"
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name = aws_db_subnet_group.db.name
}

resource "aws_db_subnet_group" "db" {
  subnet_ids = var.db_subnet_ids
}
