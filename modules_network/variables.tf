variable "region" {
  default = "eu-west-2"
}

variable "public_key_path" {
  description = "Public key path"
  default = "~/terraform/modules_network/aws_key.pub"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-09a2a0f7d2db8baca"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}

variable "environment_tag" {
  description = "Environment tag"
  default = "Production"
}

