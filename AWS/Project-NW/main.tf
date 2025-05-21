################## Provider setup for AWS #################################
provider "aws" {
  region = var.aws_region
}

################### Create a VPC ###########################################
resource "aws_vpc" "rdx_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

##################### Create an Internet Gateway for the VPC ################
resource "aws_internet_gateway" "rdx_igw" {
  vpc_id = aws_vpc.rdx_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

###################### Create a public route table ############################
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
  availability_zone = "ap-northeast-1a"
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

############ Security Group for tr EC2 allowing SSH from anywhere ##################
resource "aws_security_group" "tr_sg" {
  vpc_id = aws_vpc.rdx_vpc.id
  name   = var.tr_sg_name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 0
    to_port     = 64200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow custom TCP ports
  }

  ingress {
    from_port   = 0
    to_port     = 64200
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow custom UDP ports
  }

  ingress {
    from_port   = 0
    to_port     = 64295
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow custom UDP ports
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.tr_sg_name
  }
}

######### Security Group for nw EC2 allowing SSH from anywhere ##############################
resource "aws_security_group" "nw_sg" {
  vpc_id = aws_vpc.rdx_vpc.id
  name   = var.nw_sg_name

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
    Name = var.nw_sg_name
  }
}

################### tr EC2 Instance ##################################################
resource "aws_instance" "tr_ec2" {
  ami                    = var.tr_ami
  instance_type          = var.tr_instance_type
  subnet_id              = aws_subnet.rdx_subnet.id
  key_name               = var.keypair_name
  vpc_security_group_ids = [aws_security_group.tr_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.tr_ec2_name
  }
}

################### nw EC2 Instance #####################################################
resource "aws_instance" "nw_ec2" {
  ami                    = var.nw_ami
  instance_type          = var.nw_instance_type
  subnet_id              = aws_subnet.rdx_subnet.id
  key_name               = var.keypair_name
  vpc_security_group_ids = [aws_security_group.nw_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.nw_ec2_name
  }
}

################## Traffic Mirror Filter #######################################################
resource "aws_ec2_traffic_mirror_filter" "tm_filter" {
  description = var.tm_filter_name
}

# Traffic Mirror Ingress Rule
resource "aws_ec2_traffic_mirror_filter_rule" "tm_ingress_rule" {
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.tm_filter.id
  rule_action              = "accept"
  rule_number              = 100
  traffic_direction        = "ingress"
  source_cidr_block        = "0.0.0.0/0"
  destination_cidr_block   = "0.0.0.0/0"
  protocol                 = 0
}

# Traffic Mirror Egress Rule
resource "aws_ec2_traffic_mirror_filter_rule" "tm_egress_rule" {
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.tm_filter.id
  rule_action              = "accept"
  rule_number              = 100
  traffic_direction        = "egress"
  source_cidr_block        = "0.0.0.0/0"
  destination_cidr_block   = "0.0.0.0/0"
  protocol                 = 0
}

################### Traffic Mirror Target (nw EC2) ###########################################
resource "aws_ec2_traffic_mirror_target" "tm_target" {
  network_interface_id = aws_instance.nw_ec2.primary_network_interface_id
  description          = var.tm_target_name
}

################### Traffic Mirror Session #####################################################
resource "aws_ec2_traffic_mirror_session" "tm_session" {
  network_interface_id        = aws_instance.tr_ec2.primary_network_interface_id
  traffic_mirror_target_id    = aws_ec2_traffic_mirror_target.tm_target.id
  traffic_mirror_filter_id    = aws_ec2_traffic_mirror_filter.tm_filter.id
  session_number              = 1
}
