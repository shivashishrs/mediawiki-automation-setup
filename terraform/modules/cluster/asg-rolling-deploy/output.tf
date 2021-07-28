output "asg_name" {
  description = "Name of the auto scaling group"
  value = aws_autoscaling_group.app.name
}

output "instance_sg" {
  description = "ID of the instance security group"
  value = aws_security_group.instance.id
}