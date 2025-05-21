terraform {
    required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
} 

provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "rdx_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "rdx_igw" {
  vpc_id = aws_vpc.rdx_vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "rdx_public_route" {
  vpc_id = aws_vpc.rdx_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rdx_igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-route"
  }
}  

###################### Create a Subnet  ###########################################         
resource "aws_subnet" "rdx_subnet" {
  vpc_id            = aws_vpc.rdx_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
  }
}

###################### Associate the route table with the subnet #####################
resource "aws_route_table_association" "rdx_route_association" {
  subnet_id      = aws_subnet.rdx_subnet.id
  route_table_id = aws_route_table.rdx_public_route.id
}

######### Security Group for rdx EC2 allowing SSH from anywhere ##############################
resource "aws_security_group" "rdx_sg" {
  vpc_id = aws_vpc.rdx_vpc.id
  name   = var.sg_name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow UDP port 4789 for VXLAN
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP (ping)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

################### rdx EC2 Instance #####################################################
resource "aws_instance" "rdx_ec2" {
  ami                    = var.rdx_ami
  instance_type          = var.rdx_instance_type
  subnet_id              = aws_subnet.rdx_subnet.id
  key_name               = var.keypair_name
  vpc_security_group_ids = [aws_security_group.rdx_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.rdx_ec2_name
  }
}
