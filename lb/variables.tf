variable "region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_id" {
  description = "Target ec2 instance id"
  type        = string
}
