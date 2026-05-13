resource "aws_route53_record" "www" {
    for_each = var.instances # this will create an A record for each element in the list and the key will be the element itself
    zone_id = var.zone_id
    # interpolation 
    name = "${each.key}.${var.domain_name}" # this will create A record for each instance in the list with the name of the instance and the domain name
    type = "A"
    ttl = 1
    records = [aws_instance.example[each.key].public_ip] # this will create A record for each instance in the list with the public IP of the instance
    allow_overwrite = true
}

resource "aws_route53_record" frontend {
    zone_id = var.zone_id
    name = "techdaws.${var.domain_name}" # this will create A record for each instance in the list with the name of the instance and the domain name
    type = "A"
    ttl = 1
    records = lookup(aws_instance.example,"frontend").public_ip
    allow_overwrite = true
}