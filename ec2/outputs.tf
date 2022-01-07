output "instance_id" {
  value = aws_instance.web.id
}

output "ec2_security_group_id" {
  value = aws_security_group.web_sg.id
}
