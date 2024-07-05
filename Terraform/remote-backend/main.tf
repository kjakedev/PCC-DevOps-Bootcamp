provider "aws" {
  region = "us-east-1"
}

# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-${random_string.bucket_name.result}"
     
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_string" "bucket_name" {
    length = 8
    min_lower = 8
    special = false
}

resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
      status = "Enabled"
    }
}

# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "app-state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}