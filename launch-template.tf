# Launch Template

resource "aws_launch_template" "tomcat_server_LT" {
  name        = "tomcat_server_LT"
  description = "tomcat server launch template"
  image_id    = aws_ami_from_instance.tomcat_server_image.id

  instance_type = var.tomcat_server_ec2_instance_type

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0124
    }
  }


  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }


  vpc_security_group_ids = [aws_security_group.priv_sg.id]




  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 4
    }
  }

  #   capacity_reservation_specification {
  #     capacity_reservation_preference = "open"
  #   }


  #   placement {
  #     availability_zone = "us-west-2a"
  #   }



  #   tag_specifications {
  #     resource_type = "instance"

  #     tags = {
  #       Name = "test"
  #     }
  #   }

  #   user_data = filebase64("${path.module}/example.sh")
}