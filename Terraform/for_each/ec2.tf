resource "aws_instance" "example" {
    for_each = var.instances # this will create an instance for each element in the list and the key will be the element itself
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = each.value # this will set the instance type to the value of the element in the list
  vpc_security_group_ids = [aws_security_group.allow_tls.id]  

  tags = {
    Name = each.key # this will set the name of the instance to the key of the element in the list
    project = "roboshop"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform" # this is for AWS account 
  description = "Allow TLS inbound traffic and all outbound traffic"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow-all-terraform"
  }
} 
