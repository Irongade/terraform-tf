#AutoScaling Launch Configuration
resource "aws_launch_template" "main-launch-template" {
  name_prefix   = "main-launch-template"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.aws_key.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Main Custom EC2 instance"
    }
  }

  vpc_security_group_ids = [aws_security_group.main-instance.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get -y install net-tools nginx
    MYIP=$(ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2)
    echo "Hello Team"
    echo "This is my IP: $MYIP" > /var/www/html/index.html
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

#Generate Key
resource "aws_key_pair" "aws_key" {
    key_name = "aws_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "main-autoscaling" {
  name                      = "main-autoscaling"
  launch_template {
    id      = aws_launch_template.main-launch-template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.mainvpc-public-1.id, aws_subnet.mainvpc-public-2.id]
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.main-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Main Custom EC2 instance"
    propagate_at_launch = true
  }
}


output "ELB" {
  value = aws_elb.main-elb.dns_name
}
