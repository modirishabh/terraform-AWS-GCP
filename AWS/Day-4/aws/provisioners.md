# Terraform Provisioners: `file`, `remote-exec`, and `local-exec`

This guide provides an understanding of the different types of provisioners in Terraform and includes practical examples for each.

## file Provisioner

The `file` provisioner is used to transfer files from the local machine to the remote machine. This is often used to copy configuration files, scripts, or other necessary data onto a provisioned instance.

### Example

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "local/path/to/localfile.txt"
    destination = "/path/on/remote/instance/file.txt"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}

### remote-exec Provisioner
The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to bootstrap the instance, start services, or perform any other setup required by the application.


```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

### local-exec Provisioner
The local-exec provisioner runs commands on the local machine executing Terraform. It can be used to perform tasks on the local machine, such as running a script or updating a local database.

```hcl
resource "null_resource" "example" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'This is a local command'"
  }
}
