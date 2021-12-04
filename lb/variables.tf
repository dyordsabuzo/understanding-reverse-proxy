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
  description = "hosted zone id"
  type        = string
}

variable "record_name" {
  description = "Record name"
  type        = string
}
