locals {
    ami_id = data.aws_ami.joindevops.id
    environment = terraform.workspace
}
