resource "aws_key_pair" "aws_key" {
    key_name = "aws_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "MyFirstInstance" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name
  availability_zone = "eu-west-2a"

  user_data = file("installapache.sh")
  
  tags = {
    Name = "custom_instance"
  }

}


output "public_ip" {
  value = aws_instance.MyFirstInstance.public_ip
}
