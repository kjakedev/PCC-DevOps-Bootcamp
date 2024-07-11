###############################################################
#
# This file contains configuration for all EC2 resources
# ENI, EC2 instance, key-pair, ENI->Security group associations
# and key pair for logging in.
#
###############################################################



# Create 3 network interfaces (ENIs) which will be for the 3 cluster nodes
# We need to create these spearately from the instances themselves to prevent
# a circular dependency when setting up host files in the EC2 instances - we
# need to know the IP addresses the nodes will have before they are actually
# created.
resource "aws_network_interface" "kubenode" {
  for_each        = { for idx, inst in local.instances : inst => idx }
  subnet_id       = data.aws_subnets.public.ids[each.value]
  security_groups = [aws_security_group.egress_all.id]
  tags = {
    Name = local.instances[each.value]
  }
}

# Create the kube node instances
# The user_data will set the hostname and entries for
# all nodes in /etc/hosts
resource "aws_instance" "kubenode" {
  for_each      = toset(local.instances)
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = var.key_pair
  instance_type = "t3.medium"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.kubenode[each.value].id
  }
  tags = {
    "Name" = each.value
  }
  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname ${each.value}
              cat <<EOF >> /etc/hosts
              ${aws_network_interface.kubenode["master-node"].private_ip} master-node
              ${aws_network_interface.kubenode["worker-node01"].private_ip} worker-node01
              ${aws_network_interface.kubenode["worker-node02"].private_ip} worker-node02
              EOF
              EOT
}

# Create the bastion_host
# The user_data will set the hostname and entries for
# all nodes in /etc/hosts
resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  key_name      = var.key_pair
  vpc_security_group_ids = [
    aws_security_group.bastion_host.id,
    aws_security_group.egress_all.id
  ]
  tags = {
    "Name" = "bastion_host"
  }
  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname "bastion-host"
              echo "${data.local_sensitive_file.private_key_pem.content}" > /home/ubuntu/.ssh/id_rsa
              chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
              chmod 600 /home/ubuntu/.ssh/id_rsa
              cat <<EOF >> /etc/hosts
              ${aws_network_interface.kubenode["master-node"].private_ip} master-node
              ${aws_network_interface.kubenode["worker-node01"].private_ip} worker-node01
              ${aws_network_interface.kubenode["worker-node02"].private_ip} worker-node02
              EOF
              apt install -y git
              git clone https://github.com/kjakedev/PCC-DevOps-Bootcamp.git /home/ubuntu/PCC-DevOps-Bootcamp
              chown -R ubuntu:ubuntu /home/ubuntu/PCC-DevOps-Bootcamp
              apt-add-repository ppa:ansible/ansible
              apt update
              apt install -y ansible
              EOT
}

# Attach master-node security group to master-node ENI
resource "aws_network_interface_sg_attachment" "master-node_sg_attachment" {
  security_group_id    = aws_security_group.masternode.id
  network_interface_id = aws_instance.kubenode["master-node"].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "master-node_sg_attachment_weave" {
  security_group_id    = aws_security_group.weave.id
  network_interface_id = aws_instance.kubenode["master-node"].primary_network_interface_id
}

# Attach workernodes security group to worker-node01 ENI
resource "aws_network_interface_sg_attachment" "worker-node01_sg_attachment" {
  security_group_id    = aws_security_group.workernode.id
  network_interface_id = aws_instance.kubenode["worker-node01"].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "worker-node01_sg_attachment_weave" {
  security_group_id    = aws_security_group.weave.id
  network_interface_id = aws_instance.kubenode["worker-node01"].primary_network_interface_id
}

# Attach workernodes security group to worker-node02 ENI
resource "aws_network_interface_sg_attachment" "worker-node02_sg_attachment" {
  security_group_id    = aws_security_group.workernode.id
  network_interface_id = aws_instance.kubenode["worker-node02"].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "worker-node02_sg_attachment_weave" {
  security_group_id    = aws_security_group.weave.id
  network_interface_id = aws_instance.kubenode["worker-node02"].primary_network_interface_id
}

