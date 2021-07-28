terraform {
  required_version = ">=1.0, < 1.1"
}

resource "aws_lb" "app" {
  name = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets = var.subnet_ids
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port = local.http_port
  protocol = "HTTP"
  # By default, redirects to HTTPS
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}


resource "aws_security_group" "lb" {
  name = "${var.cluster_name}-alb-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "alb_ingress" {
  count = length(var.ingress_rules)

  description = var.rules[var.ingress_rules[count.index]]["3"]
  from_port = var.rules[var.ingress_rules[count.index]]["0"]
  to_port = var.rules[var.ingress_rules[count.index]]["1"]

  protocol = var.rules[var.ingress_rules[count.index]]["2"]
  security_group_id = aws_security_group.lb.id

  cidr_blocks = ["0.0.0.0/0"]

  type = "ingress"
}

resource "aws_security_group_rule" "alb_egress" {
  count = length(var.egress_rules)

  description = var.rules[var.egress_rules[count.index]]["3"]
  from_port = var.rules[var.egress_rules[count.index]]["0"]
  to_port = var.rules[var.egress_rules[count.index]]["1"]

  protocol = var.rules[var.egress_rules[count.index]]["2"]
  security_group_id = aws_security_group.lb.id
  cidr_blocks = ["0.0.0.0/0"]
  type = "egress"
}


locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}