provider "aws" {
    region = "us-east-2"
  
}

variable "ami" {    
  
}
variable "instance_type" {
    description = "This is the value on instance type"
    type = map(string)
    
    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
    }
  
}
resource "aws_instance" "xdr" {
        ami = var.ami
        instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}
