locals {
  cachingDisabled  = data.aws_cloudfront_cache_policy.cachingDisabled.id
  cachingOptimized = data.aws_cloudfront_cache_policy.cachingOptimized.id
  acm_certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
  common_tags = {
    Project     = var.project
    Environment = var.environment
    terraform   = "true"
  }
}