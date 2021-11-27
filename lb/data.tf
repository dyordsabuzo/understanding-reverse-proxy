data "aws_subnet_ids" "subnets" {
  vpc_id = aws_default_vpc.default.id
}

data "aws_instance" "ec2" {
  filter {
    name   = "tag:Name"
    values = ["ec2-reverse-proxy"]
  }
}
