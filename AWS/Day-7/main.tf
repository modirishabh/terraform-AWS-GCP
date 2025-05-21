provider "aws" {
    region = "us-east-2"
  
}

provider "vault" {
      address = "http://3.15.194.64:8200"
      skip_child_token = true 

      auth_login {
        path = "auth/approle/login"
      
        parameters = {
            role_id = "a79be271-a1b1-e0c4-226f-e13115cc46c0"
            secret_id = "ba722cfe-925c-097f-e80b-9cd1c243f02f"
      } 
   }
}  

data "vault_kv_secret_v2" "example"  {
    mount = "kv"
    name = "test-secret"
  
}

resource "aws_instance" "name" {
    ami = "ami-00eb69d236edcfaf8"
    instance_type = "t2.micro"

    tags = {
      secret = data.vault_kv_secret_v2.example.data["user-name"]
    }  
} 
