# IAM Instance profile
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "instance_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.instance_role.name
}

# EC2
resource "aws_instance" "tomcat_server" {
  ami = var.tomcat_server_ami_id

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0124
    }
  }
  instance_type               = var.tomcat_server_ec2_instance_type
  subnet_id                   = aws_subnet.pub_subnet1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.priv_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "tomcat-server"
  }

  user_data = file("./start-up-script.sh")
}



# AMI
resource "aws_ami_from_instance" "tomcat_server_image" {
  name               = "tomcat server image"
  source_instance_id = aws_instance.tomcat_server.id

  tags = {
    Name : "tomcat server image"
  }
}

# Auto Scaling Group
# Target group
# ALB