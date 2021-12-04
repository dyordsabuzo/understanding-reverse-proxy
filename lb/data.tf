data "aws_subnet_ids" "subnets" {
  vpc_id = aws_default_vpc.default.id
}

