resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.group2_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.group2_ALB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:034362037152:certificate/55114ddc-b0d1-495c-ae09-972402a8cec1"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tomcat_servers_TG.arn
  }
}