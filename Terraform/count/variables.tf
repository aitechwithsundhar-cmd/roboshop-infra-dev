variable "instances" {
    type = list(string)
    default = ["mongodb", "redis", "mysql","rabbitmq","catalogue","users","cart","shipping","payment","frontend"]
    }

variable "zone_id" {
    default = "Z00261213KEKMBRHYD2W"
}

variable "domain_name"{
    default = "techdaws.online"
}

variable "fruits" {
    type = list(string)
    default = ["apple", "banana", "apple", "orange"]
}

