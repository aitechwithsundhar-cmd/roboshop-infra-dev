variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "sg_names" {
  type = list(string)
  default = [
    #database security group
    "mongodb", "mysql", "redis", "rabbitmq",
    #backend security group
    "catalogue", "cart", "user", "shipping", "payment",
    #backend ALB
    "backend_alb",
    #frontend 
    "frontend",
    #frontend ALB
    "frontend_alb",
    #bastion host
    "bastion"
  ]
}