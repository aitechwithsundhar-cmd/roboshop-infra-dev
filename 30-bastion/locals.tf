locals {
  ami_id = data.aws_ami.joindevops.id
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
  # public subnet in !a AZ will be used for bastion host
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  bastion_sg_id    = data.aws_ssm_parameter.bastion_sg_id.value

}