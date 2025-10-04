packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  default = "eu-west-2"
}

source "amazon-ebs" "ubuntu" {
  region           = var.region
  instance_type    = "t2.micro"
  ssh_username     = "ubuntu"
  ami_name         = "scenario1-packer-{{timestamp}}"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "file" {
    source      = "./helloworld.txt"
    destination = "/home/ubuntu/"
  }

  provisioner "shell" {
    inline = [
      "ls -al /home/ubuntu",
      "cat /home/ubuntu/helloworld.txt"
    ]
  }

  provisioner "shell" {
    script = "./install_nginx.sh"
  }
}

