variable "instance_type" {
  type = map(any)
  default = {
    "example"        = "t2.micro"
    "other_instance" = "t4g.micro"
  }
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"

}

variable "bucket_name" {
  type    = string
  default = "terraform-remote-state-2025-02-18"
}