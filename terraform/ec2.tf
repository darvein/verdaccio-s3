data "aws_ami" "ubuntu20" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

resource "aws_instance" "verdaccio" {
  ami                    = data.aws_ami.ubuntu20.id
  key_name               = aws_key_pair.keypair.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = tolist(data.aws_subnet_ids.subnets.ids)[0]
  iam_instance_profile   = aws_iam_instance_profile.profile.name

  tags = merge(
    var.general_tags,
    { Name = format("%s", var.project_name) }
  )
}

resource "aws_security_group" "sg" {
  name        = format("%s-sg", var.project_name)
  description = "Verdaccio Security Group"

  vpc_id = var.vpc_id

  ingress {
    to_port     = var.ssh_port
    from_port   = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.ssh_sg_access_cidr]
    description = "SSH open to the VPCs CIDR"
  }

  ingress {
    to_port     = var.application_port
    from_port   = var.application_port
    protocol    = "tcp"
    cidr_blocks = [var.app_sg_access_cidr]
    description = "HTTP open to the world"
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.general_tags,
    { Name = format("%s-sg", var.project_name) }
  )
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.verdaccio.id
}
