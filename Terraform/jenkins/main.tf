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
                                git clone https://github.com/${var.github_username}/PCC-DevOps-Bootcamp.git /home/ec2-user/PCC-DevOps-Bootcamp
                                chown -R ubuntu:ubuntu /home/ubuntu/PCC-DevOps-Bootcamp
                                yum update
                                sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                                rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                                yum upgrade -y
                                dnf install java-17-amazon-corretto -y
                                yum install jenkins -y
                                systemctl enable jenkins
                                curl  https://jenkins-backup-pcc-devops.s3.amazonaws.com/jenkins_backup.tar.gz -o /tmp/jenkins_backup.tar.gz
                                echo "11c45387d6371d0397d7b5609b06c1982a" > /tmp/pcc-devops-token
                                tar -xzvf /tmp/jenkins_backup.tar.gz --strip-components=3 -C /var/lib/jenkins/
                                sed -i 's/python-todo\.publicIP/${aws_instance.python-todo.public_ip}/g' /var/lib/jenkins/nodes/python-todo/config.xml
                                sed -i 's/kjakedev/${var.github_username}/g' /var/lib/jenkins/jobs/python-todo/config.xml
                                systemctl start jenkins
                                EOT


  tags = {
    "Name" = "jenkins-demo"
  }
}


resource "aws_instance" "python-todo" {
  ami                         = "ami-04b70fa74e45c3917"
  instance_type               = "t2.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.python-todo.id]
  user_data                   = <<-EOT
                                #!/bin/bash
                                hostnamectl set-hostname "python-todo"
                                apt-get update -y
                                apt install -y python3-dev build-essential
                                apt install -y libssl1.1
                                apt install -y libssl1.1=1.1.1f-1ubuntu2
                                apt install -y libssl-dev
                                apt install -y libmysqlclient-dev
                                apt install -y python3.12-venv
                                apt install -y libvirt-dev

                                git clone https://github.com/${var.github_username}/PCC-DevOps-Bootcamp.git /home/ubuntu/PCC-DevOps-Bootcamp
                                chown -R ubuntu:ubuntu  /home/ubuntu/PCC-DevOps-Bootcamp

                                apt install openjdk-11-jdk -y
                                apt install docker.io -y
                                usermod -a -G docker ubuntu
                                EOT


  tags = {
    "Name" = "python-todo"
  }
}


resource "aws_security_group" "python-todo" {
  name        = "python-todo"
  description = "Allow Port 22 and 8080"

  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
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