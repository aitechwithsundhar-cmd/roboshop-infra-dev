resource "aws_instance" "catalogue" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.private_subnet_ids
  vpc_security_group_ids = [local.catalogue_sg_id]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )
}

resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]
    connection {
        type        = "ssh"
        user        = "ec2-user"
        password    = "DevOps321"
        host        = aws_instance.catalogue.private_ip
    }
    provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap-host.sh"
    }

    provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/bootstrap-host.sh",
    "sudo sh /tmp/bootstrap-host.sh catalogue dev"
  ]
}
}