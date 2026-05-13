output "instance_ips" {
  value = {
    for i in aws_instance.example :
    i.tags.Name => i.public_ip
  }
}