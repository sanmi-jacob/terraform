terraform {
  backend "s3" {
    bucket = "terraform-backnd-s3"
    key    = "backend"
    region = "eu-west-2"
  }
}
