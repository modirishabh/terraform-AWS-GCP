provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "xdr" {
  instance_type = "t2.micro"
  ami = "ami-036841078a4b68e14" # change this
  subnet_id = "subnet-08a1c6db53b8d5b7c" # change this
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "s3-xdr-demo-xyz" # change this
}

#resource "aws_dynamodb_table" "terraform_lock" {
#  name           = "terraform-lock"
#  billing_mode   = "PAY_PER_REQUEST"
#  hash_key       = "LockID"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}
