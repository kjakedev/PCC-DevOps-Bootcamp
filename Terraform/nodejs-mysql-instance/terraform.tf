terraform {
  backend "s3" {
    bucket         = "tfstate-nzrtxjad"
    key            = "blue-green-instance/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "app-state"
  }
}