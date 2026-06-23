# BASTION SECURITY GROUP RULES
# Allow SSH access from my laptop/public IP
# so I can connect to the bastion host.
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
# MONGODB SECURITY GROUP RULES
# Allow Bastion to SSH into MongoDB server
# for troubleshooting and administration.
resource "aws_security_group_rule" "mongodb_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mongodb_sg_id
}
# Allow Catalogue service to connect to MongoDB
# on MongoDB default port 27017.
resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = local.catalogue_sg_id
  security_group_id        = local.mongodb_sg_id
}
# Allow User service to connect to MongoDB
# on MongoDB default port 27017.
resource "aws_security_group_rule" "mongodb_user" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = local.user_sg_id
  security_group_id        = local.mongodb_sg_id
}
# REDIS SECURITY GROUP RULES
# Allow Bastion to SSH into Redis server.
resource "aws_security_group_rule" "redis_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.redis_sg_id
}
# Allow User service to connect to Redis cache.
resource "aws_security_group_rule" "redis_user" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = local.user_sg_id
  security_group_id        = local.redis_sg_id
}
# Allow Cart service to connect to Redis cache.
resource "aws_security_group_rule" "redis_cart" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = local.cart_sg_id
  security_group_id        = local.redis_sg_id
}
# MYSQL SECURITY GROUP RULES
# Allow Bastion to SSH into MySQL server.
resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mysql_sg_id
}
# Allow Shipping service to connect to MySQL
# on default MySQL port 3306.
resource "aws_security_group_rule" "mysql_shipping" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = local.shipping_sg_id
  security_group_id        = local.mysql_sg_id
}
# RABBITMQ SECURITY GROUP RULES
# Allow Bastion to SSH into RabbitMQ server.
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.rabbitmq_sg_id
}
# Allow Payment service to connect to RabbitMQ
# on AMQP port 5672.
resource "aws_security_group_rule" "rabbitmq_payment" {
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  source_security_group_id = local.payment_sg_id
  security_group_id        = local.rabbitmq_sg_id
}
# CATALOGUE SERVICE RULES
# Allow Bastion to SSH into Catalogue server.
resource "aws_security_group_rule" "catalogue_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.catalogue_sg_id
}
# Allow Backend ALB to forward requests
# to Catalogue service on port 8080.
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = local.backend_alb_sg_id
  security_group_id        = local.catalogue_sg_id
}
# USER SERVICE RULES
# Allow Bastion to SSH into User server.
resource "aws_security_group_rule" "user_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.user_sg_id
}
# Allow Backend ALB to access User service
# on application port 8080.
resource "aws_security_group_rule" "user_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = local.backend_alb_sg_id
  security_group_id        = local.user_sg_id
}
# CART SERVICE RULES
# Allow Bastion to SSH into Cart server.
resource "aws_security_group_rule" "cart_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.cart_sg_id
}
# Allow Backend ALB to access Cart service
# on application port 8080.
resource "aws_security_group_rule" "cart_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = local.backend_alb_sg_id
  security_group_id        = local.cart_sg_id
}
# SHIPPING SERVICE RULES
# Allow Bastion to SSH into Shipping server.
resource "aws_security_group_rule" "shipping_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.shipping_sg_id
}
# Allow Backend ALB to access Shipping service
# on application port 8080.
resource "aws_security_group_rule" "shipping_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = local.backend_alb_sg_id
  security_group_id        = local.shipping_sg_id
}
# PAYMENT SERVICE RULES
# Allow Bastion to SSH into Payment server.
resource "aws_security_group_rule" "payment_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.payment_sg_id
}
# Allow Backend ALB to access Payment service
# on application port 8080.
resource "aws_security_group_rule" "payment_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = local.backend_alb_sg_id
  security_group_id        = local.payment_sg_id
}
# BACKEND ALB RULES
# Allow Bastion to access Backend ALB
# for testing and troubleshooting.
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# Allow Catalogue service to communicate
# with Backend ALB.
resource "aws_security_group_rule" "backend_alb_catalogue" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.catalogue_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# Allow User service to communicate
# with Backend ALB.
resource "aws_security_group_rule" "backend_alb_user" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.user_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# Allow Cart service to communicate
# with Backend ALB.
resource "aws_security_group_rule" "backend_alb_cart" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.cart_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# Allow Shipping service to communicate
# with Backend ALB.
resource "aws_security_group_rule" "backend_alb_shipping" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.shipping_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# Allow Payment service to communicate
# with Backend ALB.
resource "aws_security_group_rule" "backend_alb_payment" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.payment_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# Allow Frontend service to send API requests
# to Backend ALB.
resource "aws_security_group_rule" "backend_alb_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.frontend_sg_id
  security_group_id        = local.backend_alb_sg_id
}
# FRONTEND SECURITY GROUP RULES
# Allow Backend ALB to communicate
# with Frontend application.
resource "aws_security_group_rule" "frontend_frontend_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = local.frontend_alb_sg_id
  security_group_id        = local.frontend_sg_id
}
resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.frontend_sg_id
}
# FRONTEND ALB RULES
# Allow HTTPS traffic from anywhere
# on the internet to Frontend ALB.
resource "aws_security_group_rule" "frontend_alb_public" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.frontend_alb_sg_id
}
