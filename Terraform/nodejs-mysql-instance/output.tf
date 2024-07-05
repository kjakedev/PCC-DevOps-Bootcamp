# Output the Public IP Address of the EC2 Instance
output "public_ip" {
  value       = aws_instance.nodejs_mysql.public_ip
  description = "Public IP address of the NodeJS MySQL EC2 instance"
}