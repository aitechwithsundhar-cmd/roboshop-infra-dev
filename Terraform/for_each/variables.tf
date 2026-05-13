variable "instances" {
    type = map
    default = {
        "mongodb" = "t3.micro"
        "mysql" = "t3.small"
        "users" = "t3.micro"
        "shipping" = "t3.micro"
    }   
}

variable "zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}