# Output the Public IP Address of the EC2 Instance

output "jenkins_connect_command" {
  value       = "ssh -i ${pathexpand("~/${var.key_pair}.pem")} ec2-user@${aws_instance.jenkins.public_ip}"
  description = "Public IP of bastion_host. Connect to this address from your SSH client."
}


output "python-todo_connect_command" {
  value       = "ssh -i ${pathexpand("~/${var.key_pair}.pem")} ubuntu@${aws_instance.python-todo.public_ip}"
  description = "Public IP of bastion_host. Connect to this address from your SSH client."
}

output "jenkins_url" {
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
  description = "Public IP of bastion_host. Connect to this address from your SSH client."
}