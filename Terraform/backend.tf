terraform {
  required_version = ">= 0.15.9"
  backend "s3" {
    bucket = ""
    key    = "state/terraform.tfstate"
    region = "sa-east-1"
  }
}