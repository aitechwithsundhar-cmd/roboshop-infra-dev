resource "aws_instance" "mongodb" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = merge(
    {
      Name      = "${var.project}-${var.environment}-mongodb"
      Component = "mongodb"
    },
    local.common_tags
  )
}
resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap-host.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap-host.sh",
      "sudo sh /tmp/bootstrap-host.sh mongodb"
    ]
  }
}

resource "aws_instance" "redis" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.redis_sg_id]

  tags = merge(
    {
      Name      = "${var.project}-${var.environment}-redis"
      Component = "redis"
    },
    local.common_tags
  )
}
resource "terraform_data" "bootstrap_redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap-host.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap-host.sh",
      "sudo sh /tmp/bootstrap-host.sh redis"
    ]
  }
}


resource "aws_instance" "mysql" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.mysql_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.mysql.name

  tags = merge(
    {
      Name      = "${var.project}-${var.environment}-mysql"
      Component = "mysql"
    },
    local.common_tags
  )
}
resource "terraform_data" "bootstrap_mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap-host.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap-host.sh",
      "sudo sh /tmp/bootstrap-host.sh mysql ${var.environment}"
    ]
  }
}
resource "aws_instance" "rabbitmq" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.database_subnet_id
  vpc_security_group_ids = [local.rabbitmq_sg_id]

  tags = merge(
    {
      Name      = "${var.project}-${var.environment}-rabbitmq"
      Component = "rabbitmq"
    },
    local.common_tags
  )
}
resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap-host.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap-host.sh",
      "sudo sh /tmp/bootstrap-host.sh rabbitmq ${var.environment}"
    ]
  }
}