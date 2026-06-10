resource "aws_instance" "catalogue" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.private_subnet_ids[0]
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
        destination = "/tmp/bootstrap-host.sh ${var.environment} ${var.app_version}"
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
    name               = "${var.project}-${var.environment}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"
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
  port     = 8080
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
  force_delete              = false

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }

  vpc_zone_identifier = local.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.catalogue.arn]

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }

    triggers = ["launch_template"]
  }

dynamic "tag" {
  for_each = merge(
    {
      Name      = "${var.project}-${var.environment}-catalogue"
      Component = "catalogue"
    },
    local.common_tags
  )

  content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
  }
}

  timeouts {
    delete = "15m"
  }
}

# auto scaling policy to scale out when cpu utilization is more than 70% for 5 min
resource "aws_autoscaling_policy" "catalogue_scale_out" {
  name                   = "${var.project}-${var.environment}-catalogue"
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  policy_type            = "TargetTrackingScaling"  
  estimated_instance_warmup = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

# listener rules to forward traffic to target group
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }
  condition {
    host_header {
      values = ["catalogue.backend-${var.environment}.${var.domain_name}"]
    }

}
}

# aws command to destory instance 
resource "terraform_data" "catalogue_delete" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]
    depends_on = [aws_autoscaling_policy.catalogue_scale_out]
# it excutes in bastion 
    provisioner "local-exec" {
command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
    }
}                       