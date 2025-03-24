resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-20250313"

  tags = {
    Name = "Terraform state"
  }
}

