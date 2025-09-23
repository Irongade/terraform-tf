resource "aws_key_pair" "aws_key" {
    key_name = "aws_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstance" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name
  availability_zone = "eu-west-2a"

  tags = {
    Name = "custom_instance"
  }

  iam_instance_profile = aws_iam_instance_profile.s3-mainbucket-role-instanceprofile.name
}

output "public_ip" {
  value = aws_instance.MyFirstInstance.public_ip
}

