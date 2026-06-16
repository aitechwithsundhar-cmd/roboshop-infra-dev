locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}