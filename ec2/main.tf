resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.profile.id
  user_data                   = data.template_cloudinit_config.config.rendered
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = merge(local.tags, {
    Name = "ec2-reverse-proxy"
  })
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2-reverse-proxy-profile"
  role = aws_iam_role.role.name
  tags = local.tags
}

resource "aws_iam_role" "role" {
  name                = "ec2-reverse-proxy-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  tags                = local.tags
}

resource "aws_security_group" "web_sg" {
  name        = "ec2-reverse-proxy-sg"
  description = "Allow traffic flow for reverse proxy"

  ingress {
    from_port   = 8080
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "web-proxy-access"
  })
}
