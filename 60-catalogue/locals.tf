locals {
  catalogue_sg_id  = data.aws_ssm_parameter.catalogue_sg_id.value
  ami_id           = data.aws_ami.joindevops.id
  vpc_id           = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}

