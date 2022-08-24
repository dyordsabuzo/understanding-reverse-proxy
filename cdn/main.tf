resource "aws_cloudfront_distribution" "cf" {
  aliases = [for alias in var.aliases : "${alias}.${var.domain_name}"]
  comment = "Cloudfront web proxy"
  enabled = true

  origin {
    origin_id   = var.origin_endpoint
    domain_name = var.origin_endpoint

    custom_origin_config {
      http_port              = 8080
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = var.origin_endpoint
    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    max_ttl                    = 0
    default_ttl                = 0
    response_headers_policy_id = aws_cloudfront_response_headers_policy.policy.id

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name = var.domain_name
  }
}

resource "aws_route53_record" "endpoints" {
  for_each = toset(var.aliases)
  zone_id  = var.hosted_zone_id
  name     = each.key
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf.domain_name
    zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_cloudfront_function" "function" {
  name    = "security-header-function"
  comment = "Setup security response headers"
  runtime = "cloudfront-js-1.0"
  code    = file("${path.module}/function.js")
}

resource "aws_cloudfront_response_headers_policy" "policy" {
  name    = "security-response-headers-policy"
  comment = "Security Response headers policy"

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = false
    }

    content_type_options {
      override = false
    }

    xss_protection {
      protection = true
      mode_block = true
      override   = false
    }

    referrer_policy {
      referrer_policy = "same-origin"
      override        = false
    }
  }
}
