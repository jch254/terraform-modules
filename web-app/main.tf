resource "aws_s3_bucket" "apex_bucket" {
  bucket        = var.bucket_name
  acl           = "public-read"
  force_destroy = true

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
    "Effect":"Allow",
    "Principal": "*",
    "Action":"s3:GetObject",
    "Resource":["arn:aws:s3:::${var.bucket_name}/*"]
  }]
}
POLICY

}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  aliases = length(var.dns_names) > 0 ? var.dns_names : null
  default_root_object = "index.html"
  price_class = "PriceClass_All"

  origin {
    domain_name = aws_s3_bucket.apex_bucket.bucket_domain_name
    origin_id = "apex_bucket_origin"
  }

  custom_error_response {
    error_code = "404"
    response_code = "200"
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "apex_bucket_origin"
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_arn != null && var.acm_arn != "" ? var.acm_arn : null
    ssl_support_method       = var.acm_arn != null && var.acm_arn != "" ? "sni-only" : null
    minimum_protocol_version = var.acm_arn != null && var.acm_arn != "" ? "TLSv1" : null
    cloudfront_default_certificate = var.acm_arn == null || var.acm_arn == ""
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "apex_route53_record" {
  count = var.route53_zone_id != null && var.route53_zone_id != "" ? length(var.dns_names) : 0

  zone_id = var.route53_zone_id
  name = var.dns_names[count.index]
  type = "A"

  alias {
    name = aws_cloudfront_distribution.cdn.domain_name
    zone_id = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
