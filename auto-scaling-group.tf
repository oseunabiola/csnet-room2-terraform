resource "aws_autoscaling_group" "tomcat_server_ASG" {
  vpc_zone_identifier = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1

  target_group_arns = [aws_lb_target_group.tomcat_servers_TG.arn]

  launch_template {
    id      = aws_launch_template.tomcat_server_LT.id
    version = "$Latest"
  }
}

