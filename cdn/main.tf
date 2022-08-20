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
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.origin_endpoint
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    max_ttl                = 0
    default_ttl            = 0

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "all"
      }
    }

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = aws_lambda_function.lambda.qualified_arn
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

resource "aws_lambda_function" "lambda" {
  description      = "Lambda edge for setting security headers"
  function_name    = "lambda-set-security-headers"
  runtime          = "nodejs14.x"
  handler          = "lambda.handler"
  memory_size      = 128
  timeout          = 10
  filename         = "lambda-edge.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  role             = aws_iam_role.role.arn
  publish          = true
}

resource "aws_iam_role" "role" {
  name               = "iam-role-for-lambda-security-headers"
  description        = "IAM role for lambda security headers"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}
