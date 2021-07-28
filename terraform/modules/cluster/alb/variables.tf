# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  description = "The name to use of all cluster resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "subnet_ids" {
  description = "The Subnet IDs to deploy to"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the load balancer"
  type = string
}

variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type = map(list(any))

  # Protocols (tcp, udp, icmp, all - are allowed keywords)
  # All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
  default = {
    http = ["80", "80", "tcp", "HTTP connections"]
    https = ["443", "443", "tcp", "HTTPS connections"]
    all = ["0", "65535", "-1", "All connections"]
  }
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(string)
  default = ["http", "https"]
}

variable "egress_rules" {
  description = "All the inbound rules"
  type = list(string)
  default = ["all"]
}