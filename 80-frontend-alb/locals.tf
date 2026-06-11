locals {
  frontend_alb_sg_id  = data.aws_ssm_parameter.frontend_alb_sg_id.value
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}

