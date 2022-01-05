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

variable "record_names" {
  description = "List of endpoint record names"
  type        = list(any)
}

variable "ec2_security_group_id" {
  description = "ec2 security group id"
  type        = string
}
