################## AWS region ##########################################################
variable "aws_region" {
}

################# VPC name ############################################################# 
variable "vpc_name" {
}

################ CIDR block for the VPC ################################################
variable "vpc_cidr_block" {
}

################ Subnet for the VPC ################################################
variable "subnet_cidr_block" {
}

################ Subnet for the VPC ################################################
variable "subnet_name" {
}

################ Security group for the VPC ################################################
variable "sg_name" {
}
################### AMI ID for the rdx EC2 instance ########################################
variable "rdx_ami" {
}

#################### Instance type for the rdx EC2 instance ################################
variable "rdx_instance_type" {
}

##################### Name of the rdx EC2 instance ##########################################
variable "rdx_ec2_name" {
}

###################### SSH keypair name for EC2 instances #####################################
variable "keypair_name" {
}

