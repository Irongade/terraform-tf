# Variable for Create Instance Module
variable "public_key_path" {
  description = "Public key path"
  default = "~/terraform/modules_network/aws_key.pub"
}

variable "VPC_ID" {
    type = string
    default = ""
}

variable "ENVIRONMENT" {
    type    = string
    default = ""
}

variable "AWS_REGION" {
default = "eu-west-2"
}

variable "AMIS" {
  type = map
  default = {
    us-east-1 = "ami-0f40c8f97004632f9"
    us-east-2 = "ami-05692172625678b4e"
    eu-west-2 = "ami-09a2a0f7d2db8baca"
    eu-west-1 = "ami-0f29c8402f8cce65c"
    us-west-1 = "ami-0f40c8f97004632f9"
  }
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "PUBLIC_SUBNETS" {
  type = list
}
