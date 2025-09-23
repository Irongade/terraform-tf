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
}

#Generate Key
resource "aws_key_pair" "aws_key" {
    key_name = "aws_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "main-autoscaling" {
  name                      = "main-autoscaling"
  vpc_zone_identifier       = ["subnet-031538e1cb9ee4c7a", "subnet-0ccc9687107d791ab"]
  launch_template {
    id      = aws_launch_template.main-launch-template.id
    version = "$Latest"
  }
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Main Custom EC2 instance"
    propagate_at_launch = true
  }
}

#Autoscaling Configuration policy - Scaling Alarm
resource "aws_autoscaling_policy" "main-cpu-policy" {
  name                   = "main-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.main-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#Auto scaling Cloud Watch Monitoring
resource "aws_cloudwatch_metric_alarm" "main-cpu-alarm" {
  alarm_name          = "main-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.main-cpu-policy.arn]
}

#Auto Descaling Policy
resource "aws_autoscaling_policy" "main-cpu-policy-scaledown" {
  name                   = "main-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.main-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#Auto descaling cloud watch 
resource "aws_cloudwatch_metric_alarm" "main-cpu-alarm-scaledown" {
  alarm_name          = "main-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.main-cpu-policy-scaledown.arn]
}
