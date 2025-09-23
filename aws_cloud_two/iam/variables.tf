variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-2"
}

variable "Security_Group" {
  type = list(string)
  default = ["sg-24076", "sg-90890", "sg-456789"]
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


variable "PATH_TO_PRIVATE_KEY" {
  default = "aws_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "aws_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
