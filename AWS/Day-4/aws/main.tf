
# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "key" {
  key_name   = "rdx-key"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

# Create a VPC
resource "aws_vpc" "rdx" {
  cidr_block = "10.2.0.0/16"
}


resource "aws_subnet" "snet" {
  vpc_id     = aws_vpc.rdx.id
  cidr_block = "10.2.0.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-rdx"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rdx.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.rdx.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-rdx"
  }
}

resource "aws_route_table_association" "rtal1" {
    subnet_id = aws_subnet.snet.id
    route_table_id = aws_route_table.rt.id
  
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.rdx.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rdx-sg"
  }
}

resource "aws_instance" "rdx-server" {
    ami = "ami-036841078a4b68e14"
    instance_type = "t2.micro"
    key_name = aws_key_pair.key.key_name
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.snet.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

  provisioner "file" {
    source = "~/terraform-zero-to-hero/Day-5/old/app.py"
    destination = "/home/ubuntu/app.py"

  } 

  provisioner "remote-exec" {
    inline = [ 
      "echo 'hello for rishabh'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",

     ]
    
  }

}

output "public_ip" {
    value = aws_instance.rdx-server.public_ip
  
}


