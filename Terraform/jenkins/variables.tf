
variable "key_pair" {
  description = "Name of the existing SSH key pair to access the EC2 instance"
  default     = "devops-bootcamp"
}


variable "github_username" {
  description = "Your github username where your forked repository is located"
}