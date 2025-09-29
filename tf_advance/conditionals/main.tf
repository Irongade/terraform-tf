provider "aws" {
  region     = var.AWS_REGION
}

module "ec2-cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.1"
  
  name            = "my-cluster"
  ami             = "ami-09a2a0f7d2db8baca"
  instance_type   = "t2.micro"
  subnet_id        = "subnet-031538e1cb9ee4c7a"
  count = var.environment == "Production" ? 2 : 1

  tags = {
    Terraform   = "true"
    Environment     = var.environment
  }
}
