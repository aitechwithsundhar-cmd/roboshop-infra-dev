resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]  

  tags = {
    Name = "terraform-remote-state"
    project = "roboshop"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform-remote-state" # this is for AWS account 
  description = "Allow TLS inbound traffic and all outbound traffic"
0
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
