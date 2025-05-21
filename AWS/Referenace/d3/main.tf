provider "aws" {
    region = "us-east-1"
  
}

module "ec2instance" {
    source = "./modules/ec2_instance"
    ami_value = "ami-0862be96e41dcbf74"
    instance_type_value = "t2.micro"
    subnet_id_value = "subnet-01e87edccde641f4c"
  
}
