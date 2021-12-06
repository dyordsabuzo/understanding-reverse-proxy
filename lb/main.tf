resource "aws_lb" "proxy" {
  name               = "lb-web-proxy"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = data.aws_subnet_ids.subnets.ids
}

resource "aws_security_group" "web_sg" {
  name        = "lb-proxy-sg"
  description = "Load balancer security firewall"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_vpc" "default" {
}

resource "aws_lb_target_group" "container" {
  for_each = toset(["8080", "8081", "8082"])
  name     = "lb-proxy-target-group-${each.key}"
  port     = each.key
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

resource "aws_lb_target_group_attachment" "target" {
  for_each         = toset(["8080", "8081", "8082"])
  target_group_arn = aws_lb_target_group.container[each.key].arn
  target_id        = var.instance_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.proxy.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.container["8080"].arn
  }
}

resource "aws_route53_record" "endpoint" {
  zone_id = var.hosted_zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.proxy.dns_name
    zone_id                = aws_lb.proxy.zone_id
    evaluate_target_health = true
  }
}
