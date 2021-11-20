data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["099720109477"]
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOT
    #!/bin/bash
    
    sudo apt update
    sudo snap install docker
    sudo addgroup --system docker
    sudo adduser ubuntu docker
    newgrp docker
    sudo snap disable docker
    sudo snap enable docker
    sudo apt install docker-compose -y
    
    mkdir /etc/ec2-reverse-proxy
    cat > /etc/ec2-reverse-proxy/docker-compose.yaml <<EOF
    ${templatefile("${path.module}/../docker-compose.yaml", {})}
    EOF
    
    cat > /etc/ec2-reverse-proxy/custom-nginx.conf <<EOF
    ${templatefile("${path.module}/../custom-nginx.conf", {})}
    EOF
    
    cd /etc/ec2-reverse-proxy && docker-compose up -d
    
    EOT
  }
}
