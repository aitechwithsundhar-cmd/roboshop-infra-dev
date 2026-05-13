variable "ingress_rules" {
    default = [
        {
            port = 22 
            cidr_blocks = ["0.0.0.0/0"]
            description = "allowing port number 22 from instance"
        },
        {
            port = 443 
            cidr_blocks = ["0.0.0.0/0"]
            description = "allowing port number 80 from instance"
        },
        {
            port = 3306 
            cidr_blocks = ["0.0.0.0/0"]
            description = "allowing port number 443 from instance"
        }
    ]
}