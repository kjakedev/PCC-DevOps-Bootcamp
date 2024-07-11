variable "access_key" {
  type        = string
  description = "Access key for AWS environment"
}

variable "secret_key" {
  type        = string
  description = "Secret key for AWS environment"
}

variable "key_pair" {
  description = "Name of the existing SSH key pair to access the EC2 instance"
}

# Names of the EC2 instances to create
locals {
  instances = [
    "master-node",
    "worker-node01",
    "worker-node02"
  ]
}

