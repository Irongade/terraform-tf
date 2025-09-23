#AWS ELB Configuration
resource "aws_elb" "main-elb" {
  name            = "main-elb"
  subnets         = [aws_subnet.mainvpc-public-1.id, aws_subnet.mainvpc-public-2.id]
  security_groups = [aws_security_group.main-elb-securitygroup.id]
  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "main-elb"
  }
}

#Security group for AWS ELB
resource "aws_security_group" "main-elb-securitygroup" {
  vpc_id      = aws_vpc.mainvpc.id
  name        = "main-elb-sg"
  description = "security group for Elastic Load Balancer"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-elb-sg"
  }
}

#Security group for the Instances
resource "aws_security_group" "main-instance" {
  vpc_id      = aws_vpc.mainvpc.id
  name        = "main-instance"
  description = "security group for instances"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.main-elb-securitygroup.id]
  }

  tags = {
    Name = "main-instance"
  }
}
