variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_id" {
  description = "Target ec2 instance id"
  type        = string
}

variable "certificate_arn" {
  description = "TLS certificate arn"
  type        = string
}

variable "hosted_zone_id" {
  description = "Hosted zone id"
  type        = string
}

variable "ec2_security_group_id" {
  type        = string
  description = "EC2 security group id"
}

variable "base_domain" {
  type        = string
  description = "Base domain"
}
