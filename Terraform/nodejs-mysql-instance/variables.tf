# Define Variables
variable "aws_region" {
  description = "AWS Region where resources will be created"
  default     = "us-east-1"
}

variable "key_pair" {
  description = "Name of the existing SSH key pair to access the EC2 instance"
}

variable "instance_name" {
  description = "Name for the EC2 instance"
}

variable "vpc_id" {
  description = "ID of existing VPC for nodejs-todo application"
}