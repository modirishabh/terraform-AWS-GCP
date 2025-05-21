provider "aws" {
    region = "us-east-2"
  
}

variable "ami" {
    description = "This is the AMI for instance"
  
}
variable "instance_type" {
    description = "This is the value on instance type"
  
}
resource "aws_instance" "rdx" {
        ami = var.ami
        instance_type = var.instance_type
}
