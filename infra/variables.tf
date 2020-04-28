variable region {
  default = "us-east-1"
}

variable name {
  default = "verdaccio"
}

variable bucket_name {
  default = "verdaccio"
  description = "S3 bucket used as Storage backend for Verdaccio"
}

variable ami {
  default = "ami-09edd32d9b0990d49" # this has docker already!
  # /aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id
  description = "AWS AMI where to deploy Verdaccio"
}

variable instance_type {
  default = "t2.small"
}

variable ssh_private_key {
  description = "Your local ssh private key that will be used to ssh into the box"
}

variable ssh_public_key {
  description = "Your public ssh key that will be assigned to the machine's ~/.ssh/authorized_keys"
}

variable ec2_subnet_id {
  description = "Existing subnet where the ec2 instances will be deployed"
}

variable ec2_sg_id {}
