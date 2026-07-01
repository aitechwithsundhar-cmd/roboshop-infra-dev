data "aws_cloudfront_cache_policy" "cachingDisabled"{
    name = "Managed-cachingDisabled"
}

data "aws_cloudfront_cache_policy" "cachingOptimized"{
    name = "Managed-cachingOptimized"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.project}/${var.environment}/frontend_alb_certificate_arn"
}