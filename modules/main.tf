module "ec2-cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.1"
  
  name            = "my-cluster"
  ami             = "ami-09a2a0f7d2db8baca"
  instance_type   = "t2.micro"
  subnet_id        = "subnet-031538e1cb9ee4c7a"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
