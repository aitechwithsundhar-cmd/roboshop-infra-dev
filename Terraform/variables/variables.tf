variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0220d79f3f480ecf5"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "sg_name" {
  description = "Security Group name"
  type        = string
  default     = "allow-all-terraform"
}

variable "sg_description" {
  description = "Security Group description"
  type        = string
  default     = "Allow all inbound and outbound traffic"
}

variable "sg_from_port" {
  type    = number
  default = 0
}

variable "sg_to_port" {
  type    = number
  default = 0
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "ec2_tags" {
  description = "Tags for EC2 instance"
  type        = map(string)

  default = {
    Name    = "terraform"
    project = "roboshop"
  }
}