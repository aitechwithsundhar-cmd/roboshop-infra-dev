variable "name" {
  type        = string
  default     = "locals"
}
variable "environment" {
  type        = string
  default     = "dev"
}
# variable "name" {
#   type        = string
#   default     = "${var.name}-${var.environment}"
# }

variable "ec2_tags" {
  default = {
    Name = "locals-demo"
    environment = "prod"
  }
}
variable "sg_tags" {
  default = {
    Name = "locals-demo"
  }
}
