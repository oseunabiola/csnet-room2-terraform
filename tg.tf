resource "aws_lb_target_group" "tomcat_servers_TG" {
  name        = "room2-tomcat-TG"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
}