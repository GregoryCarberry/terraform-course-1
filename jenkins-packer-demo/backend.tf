terraform {
  backend "s3" {
    bucket = "terraform-state-tjusfrv2"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
