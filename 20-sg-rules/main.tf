resource "aws_security_group_rule" "bastion" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # cidr_blocks = ["0.0.0.0/0"]
  cidr_blocks = [local.my_ip]
  # which security group you are creating this rule for
  security_group_id = local.bastion_sg_id
}

resource "aws_security_group_rule" "mongodb_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = local.catalogue_sg_id
  security_group_id        = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = local.user_sg_id
  security_group_id        = local.mongodb_sg_id
}

resource "aws_security_group_rule" "redis_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.redis_sg_id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mysql_sg_id
}

resource "aws_security_group_rule" "rabbitmq_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.rabbitmq_sg_id
}

resource "aws_security_group" "backend_alb_bastion" {
  type                    = "ingress"
  from_port               = 80
  to_port                 = 80
  protocol                = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id       = local.backend_albsg_id
}

