terraform {
  backend "s3" {
    bucket = "terraform-remote-state-2025-02-18"
    key    = "first-steps/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-locking"
  }
}

provider "aws" {
   region = "eu-west-2"
}