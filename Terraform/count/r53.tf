resource "aws_route53_record" "www" {
    for_each = aws_instance.example # this will create an A record for each instance in the list with the name of the instance and the domain name
    zone_id = var.zone_id
    # interpolation 
    name = "${var.instances[count.index]}.${var.domain_name}" # this will create A record for each instance in the list with the name of the instance and the domain name
    type = "A"
    ttl = 1
    records = [aws_instance.example[count.index].private_ip] # this will create A record for each instance in the list with the public IP of the instance
    allow_overwrite = true
}

resource "aws_route53_record" "www" {
    zone_id = var.zone_id
    name = "${each.key}.${var.domain_name}" # this will create A record for each instance in the list with the name of the instance and the domain name
    type = "A"
    ttl = 1
    records = [aws_instance.example[index(var.instances,"frontend")].public_ip]
    allow_overwrite = true
}