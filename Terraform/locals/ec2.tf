resource "aws_instance" "example" {
  ami           = local.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.allow_tls.id]  

  tags = local.ec2_final_tags
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform-remote-state" # this is for AWS account 
  description = "Allow TLS inbound traffic and all outbound traffic"
  lifecycle {
    create_before_destroy = true
  }
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