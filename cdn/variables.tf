variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "origin_endpoint" {
  description = "Endpoint to be proxied"
  type        = string
}

variable "domain_name" {
  description = "Domain used in cloudfront"
  type        = string
}

variable "aliases" {
  description = "List of endpoints to the cloudfront resource"
  type        = list(any)
}

variable "hosted_zone_id" {
  description = "Hosted zone id of the endpoints"
  type        = string
}
