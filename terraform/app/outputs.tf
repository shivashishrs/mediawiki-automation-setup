output "loadbalancer_url" {
  description = "HTTP Endpoint of the load balancer"
  value       = module.alb.alb_url
}