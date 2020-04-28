locals {
  svc_user = "ec2-user"
}

resource "aws_key_pair" "deployer" {
  key_name = var.name
  public_key = file(var.ssh_public_key)
}

resource "aws_instance" "verdaccio" {
  ami = var.ami
  instance_type = var.instance_type

  #key_name = var.ssh_key_name
  key_name = aws_key_pair.deployer.key_name
  subnet_id = var.ec2_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile = aws_iam_instance_profile.profile.name

  # Verdaccio config file
  provisioner "file" {
    source = "../.env"
    destination = "~/dotenv"

    connection {
      type = "ssh"
      user = local.svc_user
      private_key = file(var.ssh_private_key)
      host = self.public_ip
    }
  }

  # Verdaccio HTTP Auth file
  provisioner "file" {
    source = "../conf/htpasswd"
    destination = "~/htpasswd"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file(var.ssh_private_key)
      host = self.public_ip
    }
  }

  # The bootstraper that will setup and initialize verdaccio
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "~/bootstrap.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file(var.ssh_private_key)
      host = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bootstrap.sh",
      "/bin/bash ~/bootstrap.sh"
    ]

    connection {
      type = "ssh"
      user = local.svc_user
      private_key = file(var.ssh_private_key)
      host = self.public_ip
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.verdaccio.id
}
