# terraform-aws-instance
this modules creates ec2 instance in aws 

## Inputs 
* project -( required ) string type, user must provide project name ex. roboshop, expense, etc.
* environment - (required) string type, user must provied evnironment ex. dev, uat, prod, etc. 
* ami_id - (required) string type, user must provide ami_id of the instance.
* instance_type - (optional) string type, default values is t3.micro. users can override.
* sg_id - (required) list of strings, users must provide list of security group ids isntance should have.
* tags - (optional) list type user can provide the tags they want to have.

## OutPuts 
* instance_id - ID of the instance created 
* public_ip - public IP of the instance created 
* priviet_ip - privet IP of instance created 