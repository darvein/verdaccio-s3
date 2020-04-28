resource "aws_key_pair" "deployer" {
  key_name = "verdaccio"
  public_key = file("~/tmp/ssh-dummy/dummy.pub")
}

resource "aws_instance" "verdaccio" {
  ami = var.ami
  instance_type = var.instance_type

  #key_name = var.ssh_key_name
  key_name = aws_key_pair.deployer.key_name
  subnet_id = var.ec2_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile = aws_iam_instance_profile.profile.name

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "~/bootstrap.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/tmp/ssh-dummy/dummy")
      host = self.public_ip
      #agent = true
    }
  }

  provisioner "file" {
    source = "../.env"
    destination = "~/dotenv"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/tmp/ssh-dummy/dummy")
      host = self.public_ip
      #agent = true
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/bootstrap.sh",
      "/bin/bash ~/bootstrap.sh"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/tmp/ssh-dummy/dummy")
      host = self.public_ip
      #agent = true
    }
  }

  #user_data = file("bootstrap.sh")

  tags = {
    Name = var.name
  }
}

