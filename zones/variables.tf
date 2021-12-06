variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}
