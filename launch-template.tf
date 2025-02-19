# Launch Template
resource "aws_launch_template" "tomcat_server_LT" {
  name          = "tomcat_server_LT"
  description   = "tomcat server launch template"
  image_id      = var.tomcat_server_ami_id
  instance_type = var.tomcat_server_ec2_instance_type
  key_name      = aws_key_pair.group2_instance_keypair.key_name


  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0128
    }
  }


  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  # vpc_security_group_ids = [aws_security_group.pub_sg.id]

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.pub_sg.id]
  }


  # block_device_mappings {
  #   device_name = "/dev/sdf"

  #   ebs {
  #     volume_size = 4
  #   }
  # }

  #   capacity_reservation_specification {
  #     capacity_reservation_preference = "open"
  #   }


  #   placement {
  #     availability_zone = "us-west-2a"
  #   }



  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tomcat-servers"
    }
  }

  user_data = filebase64("./scripts/httpd.sh")
}