data "aws_ssm_parameter" "backend_alb_sg_id" {
  value = "/${var.project}/${var.environment}/backend_alb_sg_id"
}

data "aws_ssm_parameter" "subnet_ids" {
  value = "/${var.project}/${var.environment}/vpc_id"
}