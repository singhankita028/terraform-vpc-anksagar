terraform {
  backend "s3" {
    bucket = "terra-anksagar-state11"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}