resource "aws_instance" "mongodb" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]
    connection {
        type        = "ssh"
        user        = "ec2-user"
        password    = "DevOps321"
        host        = aws_instance.mongodb.private_ip
    }
    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap-host.sh"
    }

    provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/bootstrap-host.sh",
    "sudo sh /tmp/bootstrap-host.sh"
  ]
}
}
