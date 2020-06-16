variable region { default = "us-east-1" }

variable project_name { default = "" }
variable bucket_name { default = "" }

variable vpc_id { default = "" }
variable instance_type { default = "t2.small" }
variable ssh_port { default = 22 }
variable application_port { default = 80 }
variable ssh_sg_access_cidr { default = "0.0.0.0/0" }
variable app_sg_access_cidr { default = "0.0.0.0/0" }

variable general_tags { default = {} }

