provider "aws" {
    region = "us-east-2"
  
}

module "ec2" {
    source = "./module/ec2"
    ami_value = "ami-036841078a4b68e14"
    instance_type_value = "t2.micro"
    subnet_id_value = "subnet-08a1c6db53b8d5b7c"
}

  
