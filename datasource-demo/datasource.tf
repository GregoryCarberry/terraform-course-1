data "terraform_remote_state" "first-steps" {
  backend = "s3"

  config = {
    bucket = "terraform-remote-state-2025-02-18"
    key    = "first-steps/terraform.tfstate"
    region = "eu-west-2"
  }
}

locals {
  vpc_id = data.terraform_remote_state.first-steps.outputs.vpc_id
}

output "vpc_id" {
  value = local.vpc_id
}