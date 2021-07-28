
resource "aws_security_group" "jb-sg" {
  name = "${ var.app_name }-jumpbox-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jumpbox" {
  ami = data.aws_ami.image.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.jb-sg.id]
  subnet_id = module.vpc.public_subnets[0]
  tags = {
    Name = "Wikimedia JumpBox"
  }
  key_name = aws_key_pair.kp.key_name
  provisioner "remote-exec" {
    inline = [
      "php /var/www/mediawiki-1.36.1/maintenance/install.php --dbuser mediawiki --dbpass '${ random_password.db_pass.result }' --dbname mediawiki --dbserver ${ module.db.db_endpoint } --with-extensions --pass ${ var.admin_password } mywiki ${ var.admin_username }"]
    connection {
      host = self.public_ip
      type = "ssh"
      user = var.ssh_user
      private_key = file(var.key_path)
    }
  }
}
