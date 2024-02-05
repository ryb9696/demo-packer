provider "aws" {
  region = "us-east-1"  
}

resource "aws_launch_template" "example" {
  name               = "my-launch-template"
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

   network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-east-1a"
  }

  vpc_security_group_ids = ["sg-0e25fdba7e46408bc"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  instance_type = "t2.micro"

  key_name = "ojt"  

  image_id = var.ami_id  
}
