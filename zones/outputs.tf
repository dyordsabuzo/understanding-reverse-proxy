output "hosted_zone_id" {
  value = aws_route53_zone.zone.zone_id
}

output "nameservers" {
  value = aws_route53_zone.zone.name_servers
}

output "domain_name" {
  value = var.domain_name
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
