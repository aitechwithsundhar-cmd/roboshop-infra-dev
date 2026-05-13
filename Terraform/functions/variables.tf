variable "common_tags" {
  #type = map(string)
  default = {
    project = "roboshop"
    terraform = "true"
    owner   = "dev"
  }
}
variable "ec2_tags" {
  default = {
    Name = "function-demo"
    environment = "prod"
  }
}
variable "sg_tags" {
  default = {
    Name = "function-demo"
  }
}