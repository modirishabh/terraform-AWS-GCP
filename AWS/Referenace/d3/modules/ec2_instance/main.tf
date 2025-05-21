provider  "aws"{
    region = "us-east-2"
}

resource "aws_instance" "EC2-LIN-DEV-DAY3-01" {
    ami = var.ami_value
    instance_type = var.instance_type_value
    subnet_id = var.subnet_id_value

}
