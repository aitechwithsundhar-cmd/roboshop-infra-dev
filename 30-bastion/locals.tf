locals {
  ami_id = data.aws_ami.joindevops.id
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
  # database subnet in la AZ will be used for bastion host
  database_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  bastion_sg_id    = data.aws_ssm_parameter.bastion_sg_id.value
  mysql_sg_id      = data.aws_ssm_parameter.mysql_sg_id.value
  mongodb_sg_id    = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id      = data.aws_ssm_parameter.redis_sg_id.value
  mysql_role_name   = join( "_", [ for name in ["${var.project}", "${var.environment}", "mysql"] : title(name)])