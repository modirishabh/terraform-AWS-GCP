# MIGRATION TO TERRAFORM & DRIFT DETECTION

# Step 1 Create an main.tf
# Step 2 add provider block and add import block
provider "aws" {
    region = "us-east-2"
}

import {
    id = "instanceid" ### string

    to = aws_instance.example 
}

# Step 3 goto terminal run command
```
terraform init
terraform plan -generate-config-out=filename.tf
```
now terraform will create configuration file  

# Step 4 Edit the above main.tf that is created in step 1 and delete the import block and copy the all content in filename.tf and paste the content in main.tf after the provider block

# Step 5 run below command
``` 
terraform import aws_instance.example(form import.to) instanceid(from import.id)
```
