# module "levelup-vpc" {
#     source      = "../module/vpc"

#     ENVIRONMENT = var.ENVIRONMENT
#     AWS_REGION  = var.AWS_REGION
# }

module "main-rds" {
    source      = "../modules/rds"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    vpc_private_subnet1 = var.vpc_private_subnet1
    vpc_private_subnet2 = var.vpc_private_subnet2
    vpc_id = var.vpc_id
}

resource "aws_security_group" "main_webservers"{
  tags = {
    Name = "${var.ENVIRONMENT}-main-webservers"
  }
  
  name          = "${var.ENVIRONMENT}-main-webservers"
  description   = "Created by main"
  vpc_id        = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.SSH_CIDR_WEB_SERVER}"]

  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Resource key pair
resource "aws_key_pair" "aws_key" {
  key_name      = "aws_key"
  public_key    = file(var.public_key_path)
}

# resource "aws_launch_configuration" "launch_config_webserver" {
#   name   = "launch_config_webserver"
#   image_id      = lookup(var.AMIS, var.AWS_REGION)
#   instance_type = var.INSTANCE_TYPE
#   user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"
#   security_groups = [aws_security_group.main_webservers.id]
#   key_name = aws_key_pair.aws_key.key_name
  
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "20"
#   }
# }

# Launch Template for Web Servers
resource "aws_launch_template" "webserver_template" {
  name_prefix   = "webserver_template_"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  key_name      = aws_key_pair.aws_key.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_webservers.id]
  }

  user_data = file("${path.module}/webserver_init.sh")

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "webserver-${var.ENVIRONMENT}"
      Environment = var.ENVIRONMENT
    }
  }
}


resource "aws_autoscaling_group" "main_webserver" {
  name                      = "main_WebServers"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  # launch_configuration      = aws_launch_configuration.launch_config_webserver.name
  vpc_zone_identifier       = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]
  target_group_arns         = [aws_lb_target_group.load-balancer-target-group.arn]

   launch_template {
    id      = aws_launch_template.webserver_template.id
  }
  
  tag {
    key                 = "Name"
    value               = "${var.ENVIRONMENT}-main-webservers"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.ENVIRONMENT
    propagate_at_launch = true
  }
}

#Application load balancer for app server
resource "aws_lb" "main-load-balancer" {
  name               = "${var.ENVIRONMENT}-main-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_webservers_alb.id]
  subnets            = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]

}

# Add Target Group
resource "aws_lb_target_group" "load-balancer-target-group" {
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Adding HTTP listener
resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.main-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
    type             = "forward"
  }
}

output "load_balancer_output" {
  value = aws_lb.main-load-balancer.dns_name
}

