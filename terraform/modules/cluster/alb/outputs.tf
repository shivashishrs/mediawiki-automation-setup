output "alb_url" {
  description = "DNS name of the load balancer"
  value = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value = aws_lb.app.arn
}

output "alb_security_group_id" {
  description = "ID of the load balancer security group"
  value = aws_security_group.lb.id
}

output "alb_http_listener_arn" {
  description = "ALB http listener"
  value = aws_lb_listener.http.arn
}
