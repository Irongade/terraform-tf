# Application Load Balancer Example. You need a target group and then a listener


# Application Load Balancer
resource "aws_lb" "main-alb" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main-alb-sg.id]
  subnets            = [aws_subnet.mainvpc-public-1.id, aws_subnet.mainvpc-public-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "main-alb"
  }
}

# Target Group for EC2s
resource "aws_lb_target_group" "main-tg" {
  name     = "main-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mainvpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "main-tg"
  }
}

# Listener for ALB
resource "aws_lb_listener" "main-listener" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-tg.arn
  }
}

