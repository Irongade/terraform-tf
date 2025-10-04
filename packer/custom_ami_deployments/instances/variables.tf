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
    default = "development"
}

variable "AWS_REGION" {
default = "eu-west-2"
}

variable "AMI_ID" {
    type    = string
    default = ""
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}
