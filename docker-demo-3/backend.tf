terraform {
  backend "s3" {
    bucket = "terraform-state-20250313"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}