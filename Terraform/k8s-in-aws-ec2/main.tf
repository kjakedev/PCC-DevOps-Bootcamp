###############################################################
#
# This file contains the provide decalarations and outputs
#
###############################################################

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "tf:stackid" = "kubeadm-cluster"
    }
  }
  access_key = var.access_key
  secret_key = var.secret_key
}

output "connect_command" {
  value       = "ssh -i ${pathexpand("~/${var.key_pair}.pem")} ubuntu@${aws_instance.bastion_host.public_ip}"
  description = "Public IP of bastion_host. Connect to this address from your SSH client."
}

output "worker-node01" {
  value = aws_instance.kubenode["worker-node01"].public_ip
}

output "worker-node02" {
  value = aws_instance.kubenode["worker-node02"].public_ip
}

output "master-node-private_ip" {
  value = aws_instance.kubenode["master-node"].private_ip
}


output "worker-node01-private_ip" {
  value = aws_instance.kubenode["worker-node01"].private_ip
}

output "worker-node02-private_ip" {
  value = aws_instance.kubenode["worker-node02"].private_ip
}

