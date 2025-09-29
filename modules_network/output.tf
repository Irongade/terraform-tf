output "public_instance_ip" {
  value = ["${aws_instance.main_instance.public_ip}"]
}
