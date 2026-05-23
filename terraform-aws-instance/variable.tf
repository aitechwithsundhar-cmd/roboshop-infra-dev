variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "sg_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}