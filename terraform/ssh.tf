resource "tls_private_key" "pem" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = format("%s-keypair", var.project_name)
  public_key = tls_private_key.pem.public_key_openssh
}
