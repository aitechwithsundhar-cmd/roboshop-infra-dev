resource "aws_cloudfront_distribution" "roboshop" {
  origin {
    domain_name              = "frontend-${var.environment}.${var.domain_name}"
    origin_id                = "frontend-${var.environment}.${var.domain_name}"
  # https://frontend-dev.techdaws.online
    custom_origin_config { 
      http_port          = 80
      https_port         = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2","TLSv1.1"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
#CDN URL https://roboshop-devtechdaws.online
  aliases = ["${var.project}-${var.environment}.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontend-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingDisabled
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "frontend-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingOptimized
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "frontend-${var.environment}.${var.domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingOptimized
  }
  price_class = "PriceClass_All"

restrictions {
  geo_restriction {
    restriction_type = "none"
  }
}

tags = merge(
  {
    Name = "${var.project}-${var.environment}-frontend"
  },
  local.common_tags
)

  viewer_certificate {
    acm_certificate_arn = local.acm_certificate_arn
    ssl_support_method = "sni-only"
  }

}

resource "aws_route53_record" "cdn" {
  zone_id = var.zone_id
  name   = "${var.project}-${var.environment}.${var.domain_name}"
  type  = "A"
  # CDN details 
  alias {
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health  = true 

  }
  allow_overwrite = true

}

