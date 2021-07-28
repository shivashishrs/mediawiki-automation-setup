terraform {
  # Require any 1.0.x version of Terraform
  required_version = ">=1.0, < 1.1"
}


module "instance_profile_role" {
  source = "../../iam/role"
  assuming_role_service = "ec2.amazonaws.com"
  env = var.environment
  project_name = var.project_name
  role_name = "${ var.project_name }-${ var.environment }-instance-role"
  additional_permissions = var.additional_permissions
}

resource "aws_iam_instance_profile" "app" {
  name = "${ var.project_name }-${ var.environment }-instance-role"
  role = module.instance_profile_role.iam_role_name
}

resource "aws_launch_configuration" "app" {
  image_id = var.ami_id
  instance_type = var.instance_type
  user_data = var.user_data
  security_groups = [aws_security_group.instance.id]
  key_name = var.key_pair
  iam_instance_profile = aws_iam_instance_profile.app.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name = "${ var.project_name }-${ var.environment }-${aws_launch_configuration.app.name}"

  launch_configuration = aws_launch_configuration.app.name
  vpc_zone_identifier = var.subnet_ids

  max_size = var.max_size
  min_size = var.min_size

  # Configurations with Load Balancer
  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_elb_capacity = var.min_size

  wait_for_capacity_timeout = 0

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = ["Name", "Project"]
    content {
      key = tag.value
      value = var.project_name
      propagate_at_launch = true
    }
  }
}

resource "aws_security_group" "instance" {

  name = "${ var.project_name }-${ var.environment }-instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  from_port = var.server_port
  protocol = local.tcp_protocol
  security_group_id = aws_security_group.instance.id
  to_port = var.server_port
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}


locals {
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}