output "public_ip_addr" {
  value = aws_eip.ip.public_ip
}

output "ssh_private_pem" {
  value = tls_private_key.pem.private_key_pem
}
