output "public_ip_addr" {
  value = aws_eip.ip.public_ip
}

output "private_ip_addr" {
  value = aws_instance.verdaccio.private_ip
}
