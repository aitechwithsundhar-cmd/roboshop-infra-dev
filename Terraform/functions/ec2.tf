resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]  

  tags = merge (
   var.common_tags, # this will add the common tags to all instances
   var.ec2_tags
  )
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
  tags = merge(
    var.common_tags, # this will add the common tags to all instances
    var.sg_tags
  )
}