data "aws_availability_zones" "zone" {}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "MyFirstInstance" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.zone.names[0] 
  

  tags = {
    Name = "custom_instance"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.MyFirstInstance.private_ip} >> my_private_ips.txt"
  }

}

output "public_ip" {
  value = aws_instance.MyFirstInstance.public_ip
}
