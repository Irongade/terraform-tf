resource "aws_key_pair" "aws_key" {
    key_name = "aws_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name

  tags = {
    Name = "custom_instance"
  }


  vpc_security_group_ids = [aws_security_group.allow-main-ssh.id]
  subnet_id = aws_subnet.mainvpc-public-2.id
}
