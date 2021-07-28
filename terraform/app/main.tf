provider "aws" {
  region = "us-east-1"
}

module "asg" {
  source                 = "../modules/cluster/asg-rolling-deploy"
  ami_id                 = data.aws_ami.image.image_id
  environment            = var.env
  key_pair               = aws_key_pair.kp.key_name
  max_size               = 3
  min_size               = 2
  project_name           = var.app_name
  subnet_ids             = module.vpc.private_subnets
  user_data              = file("user-data.sh")
  vpc_id                 = module.vpc.vpc_id
  target_group_arns      = [aws_lb_target_group.app.arn]
  instance_type          = "t3.small"
  additional_permissions = ["s3:*", "ssm:DescribeParameters", "ssm:GetParameters"]
}

resource "aws_security_group_rule" "instance" {
  from_port                = var.application_port
  protocol                 = "tcp"
  security_group_id        = module.asg.instance_sg
  to_port                  = var.application_port
  type                     = "ingress"
  source_security_group_id = module.alb.alb_security_group_id
}

data "aws_ami" "image" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "mediawiki-*"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "mediwikikey" # Create "mediwikikey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ~/.ssh/mediwikikey.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 ~/.ssh/mediwikikey.pem"
  }
}

