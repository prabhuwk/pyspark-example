provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "aaj-terraform-backend-s3"
    key    = "terraform-state/s3_bucket"
    region = "eu-west-1"
  }
}

resource "aws_s3_bucket" "staging" {
  bucket = "aaj-staging-s3-bucket"
}

resource "aws_s3_bucket" "final" {
  bucket = "aaj-final-s3-bucket"
}