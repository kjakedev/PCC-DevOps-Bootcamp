terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins" {
  ami                         = "ami-08a0d1e16fc3f61ea"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  user_data                   = <<-EOT
                                #!/usr/bin/env bash
                                hostnamectl set-hostname "jenkins-demo"
                                yum install -y git
                                git clone https://github.com/kjakedev/PCC-DevOps-Bootcamp.git /home/ec2-user/PCC-DevOps-Bootcamp
                                chown -R ubuntu:ubuntu /home/ubuntu/PCC-DevOps-Bootcamp
                                yum update
                                sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                                rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                                yum upgrade -y
                                dnf install java-17-amazon-corretto -y
                                yum install jenkins -y
                                systemctl enable jenkins
                                systemctl start jenkins
                                EOT


  tags = {
    "Name" = "jenkins-demo"
  }
}


#Jenkins Security Group Resource
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow Port 22 and 8080"

  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 8080 Traffic"
    from_port   = 8080
    to_port     = 8080
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