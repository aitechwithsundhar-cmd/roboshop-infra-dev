locals {

  common_tags = {
    project     = var.project
    environment = var.environment
    terraform   = "true"
  }

  ec2_final_tags = merge(
    local.common_tags,
    var.tags
  )

}