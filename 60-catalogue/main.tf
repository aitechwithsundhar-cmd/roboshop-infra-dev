resource "aws_instance" "catalogue" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.private_subnet_ids
  vpc_security_group_ids = [local.catalogue_sg_id]
  tags = merge(

    local.common_tags,
    {
      Name      = "${var.project}-${var.environment}-catalogue"
      Component = "catalogue"
    }
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
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]
}

resource "aws_ami_from_instance" "catalogue" {
    name               = "${var.project}-${var.environment}-catalogue-ami"
    source_instance_id = aws_instance.catalogue.id
    depends_on = [aws_ec2_instance_state.catalogue]
    description        = "AMI for ${var.project} ${var.environment} catalogue component"
    tags = merge(
        local.common_tags,
        {
        Name      = "${var.project}-${var.environment}-catalogue-ami"
        Component = "catalogue"
        }
    )
}

resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60

  health_check {
    healthy_threshold   = 2
    interval            = 10
    matcher             = "200-299"
    path                = "/health"
    port               = 8080
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }
}

resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"
  image_id      = aws_ami_from_instance.catalogue.id

  # once autoscaling sees less traffic, it will terminate the instance 
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                      = "t3.micro"
  vpc_security_group_ids              = [local.catalogue_sg_id]

  # each time we run terraform apply, it will create new version of launch template and update default version to latest one
  update_default_version = true

  # tags for instances created by launch template
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name      = "${var.project}-${var.environment}-catalogue"
        Component = "catalogue"
      },
      local.common_tags
    )
  }
    # tags for valume creted by instances
    tag_specifications {
    resource_type = "volume"  
    tags = merge(
      {
        Name      = "${var.project}-${var.environment}-catalogue"
        Component = "catalogue"
      },
      local.common_tags
    )
  }
  # this is launch tamplete
    tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name      = "${var.project}-${var.environment}-catalogue"
        Component = "catalogue"
      },
      local.common_tags
    )
  }
}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project}-${var.environment}-catalogue"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete               = false

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }

  vpc_zone_identifier = [local.private_subnet_ids]
  target_group_arns  = [aws_lb_target_group.catalogue.arn]

  tag {
    key                = "Name"
    value               = "${var.project}-${var.environment}-catalogue"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }

  tag {
    key                = "Component"
    value               = "catalogue"
    propagate_at_launch = true
  }
}