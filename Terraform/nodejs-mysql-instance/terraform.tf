terraform {
  backend "s3" {
    bucket         = "tfstate-nzrtxjad"
    key            = "jenkins-runner/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "app-state"
  }
}