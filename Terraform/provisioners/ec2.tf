resource "aws_instance" "example" {
  ami           = "ami-0220d79f3f480ecf5"
  instance_type = "t3.micro"
  key_name      = "my-key.pem"   # 

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  provisioner "local-exec" {
    command = "echo '${self.public_ip}' > inventory.ini"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroying instance'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo > inventory.ini"
  }

connection {
  type        = "ssh"
  user        = "maintuser" 
  private_key = file("/Users/ajmera/.ssh/my-key.pem")
  host        = self.public_ip
  timeout     = "5m"
  agent       = false
}

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop nginx"
    ]
    when   = destroy
  }

  tags = {
    Name    = "provisioners-demo"
    project = "roboshop"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow-all-terraform-${random_id.sg.hex}"
  description = "Allow all traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_id" "sg" {
  byte_length = 2
}