variable "AWS_REGION" {
default = "eu-west-2"
}

provider "aws" {
  region     = "eu-west-2"
}

variable "AMIS" {
  type = map
  default = {
    us-east-1 = "ami-0f40c8f97004632f9"
    us-east-2 = "ami-05692172625678b4e"
    eu-west-2 = "ami-09a2a0f7d2db8baca"
    us-west-1 = "ami-0f40c8f97004632f9"
  }
}

variable "PATH_TO_PUBLIC_KEY" {
  description = "Public key path"
  default = "~/terraform/modules_network/aws_key.pub"
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "~/terraform/modules_network/aws_key"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
