resource "aws_s3_bucket" "b" {
  bucket = "mybucket-20250220"

  tags = {
    Name = "mybucket-20250220"
  }
}

