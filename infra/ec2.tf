resource "aws_instance" "verdaccio" {
  ami = var.ami
  instance_type = var.instance_type

  key_name = var.ssh_key_name
  subnet_id = var.ec2_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile = aws_iam_instance_profile.profile.name

  user_data = file("bootstrap.sh")

  tags = {
    Name = var.name
  }
}
