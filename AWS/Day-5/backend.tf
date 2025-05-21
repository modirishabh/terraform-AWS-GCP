terraform {
  backend "s3" {
    bucket         = "s3msdmsd-xyz" # change this
    key            = "dddd/terraform.tfstate"
    region         = "us-east-2"
  }
}
