module "alb" {
  source       = "../modules/cluster/alb"
  cluster_name = "mediawiki-demo"
  subnet_ids   = module.vpc.public_subnets
  vpc_id       = module.vpc.vpc_id
}

resource "aws_alb_listener_rule" "http" {
  listener_arn = module.alb.alb_http_listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "app" {
  name       = "${var.app_name}-${var.env}"
  port       = var.application_port
  protocol   = "HTTP"
  vpc_id     = module.vpc.vpc_id
  slow_start = 180
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_ssm_parameter" "alb_host" {
  name  = "/mediawiki/${var.env}/alb/host"
  type  = "SecureString"
  value = module.alb.alb_url
}