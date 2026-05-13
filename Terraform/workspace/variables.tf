variable "project" {
    default = "roboshop"
}

variable instance_type {
    type = map(string) 

    
    default = {
    dev = "t3.micro"
    uat = "t3.small"
    prod = "t3.medium"
    }
}