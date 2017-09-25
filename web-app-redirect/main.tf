resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "${var.source_dns_name}"
  acl = "public-read"
  force_destroy = true

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
    "Effect":"Allow",
    "Principal": "*",
    "Action":"s3:GetObject",
    "Resource":["arn:aws:s3:::${var.source_dns_name}/*"]
  }]
}
POLICY

  website {
    redirect_all_requests_to = "${var.destination_dns_name}"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  aliases = ["${var.source_dns_name}"]
  price_class = "PriceClass_All"

  origin {
    domain_name = "${aws_s3_bucket.redirect_bucket.website_endpoint}"
    origin_id = "redirect_bucket_origin"

    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = [ "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "redirect_bucket_origin"
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    forwarded_values {
      query_string = true
      headers = ["*"]
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${var.acm_arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "redirect_route53_record" {
  zone_id = "${var.route53_zone_id}"
  name = "${var.source_dns_name}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
}
