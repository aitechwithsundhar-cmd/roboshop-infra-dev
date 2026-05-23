module "ec2" {
  source        = "../terraform-aws-instance"
  project       = var.project_name
  environment   = var.evn
  sg_ids        = var.sg_ids
  ami_id        = data.aws_ami.joindevops.id
  instance_type = "t3.large"

  tags = {
    Name = "${var.project_name}-${var.evn}-${var.component}"
    comoponent = var.component
  }
}