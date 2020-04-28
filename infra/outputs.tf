output "public_ip_addr" {
  value = aws_instance.verdaccio.public_ip
}

output "private_ip_addr" {
  value = aws_instance.verdaccio.private_ip
}
