resource "aws_lb" "group2_ALB" {
  name               = "group2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]

  enable_deletion_protection = false


  tags = {
    Name = "group2-alb"
  }
}


resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Configure TLS traffic rule for application load balancer"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = var.alb_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb_http_port_rule" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "lb_https_port_rule" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "lb_outbound_port_rule" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
