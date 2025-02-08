resource "aws_autoscaling_group" "tomcat_server_ASG" {
  availability_zones = [var.subnet1_az, var.subnet2_az]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.tomcat_server_LT.id
    version = "$Latest"
  }
}