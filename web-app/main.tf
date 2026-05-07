locals {
  use_acm              = var.acm_arn != null && var.acm_arn != ""
  origin_id            = "s3-${var.bucket_name}"
  has_aliases          = length(var.dns_names) > 0
  spa_fallback_enabled = var.spa_fallback_path != null && var.spa_fallback_path != ""
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, { Name = var.bucket_name })
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.bucket_name
  aliases             = var.dns_names
  default_root_object = var.default_root_object
  price_class         = var.price_class

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    # AWS-managed CachingOptimized policy
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  dynamic "custom_error_response" {
    for_each = local.spa_fallback_enabled ? toset(["403", "404"]) : toset([])
    content {
      error_code         = tonumber(custom_error_response.value)
      response_code      = 200
      response_page_path = var.spa_fallback_path
    }
  }

  viewer_certificate {
    acm_certificate_arn            = local.use_acm ? var.acm_arn : null
    ssl_support_method             = local.use_acm ? "sni-only" : null
    minimum_protocol_version       = local.use_acm ? "TLSv1.2_2021" : null
    cloudfront_default_certificate = local.use_acm ? null : true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(var.tags, { Name = var.bucket_name })

  lifecycle {
    precondition {
      condition     = !local.has_aliases || local.use_acm
      error_message = "acm_arn must be set when dns_names is non-empty (CloudFront requires an ACM cert for custom aliases)."
    }
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid     = "AllowCloudFrontReadViaOAC"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
