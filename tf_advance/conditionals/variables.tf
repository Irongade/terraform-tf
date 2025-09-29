variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "aws_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "aws_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "environment" {
    type        = string
    default     = "Production"
}
