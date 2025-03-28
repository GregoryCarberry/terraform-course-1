# aws_launch_configuration is deprecated, use aws_launch_template
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
/* resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix     = "example-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name
  security_groups = [aws_security_group.myinstance.id]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /var/www/html/index.html"
  lifecycle {
    create_before_destroy = true
  }
} */

resource "aws_launch_template" "example-launchtemplate" {
  name_prefix   = "example-launchtemplate"
  image_id      = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykeypair.key_name

  vpc_security_group_ids = [aws_security_group.myinstance.id]

  user_data = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get -y install net-tools nginx
MYIP=$(ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2)
echo "this is: $MYIP" > /var/www/html/index.html
EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ec2 instance"
    }
  }
}


resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "example-autoscaling"
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.my-elb.name]
  force_delete              = true

  launch_template {
    id      = aws_launch_template.example-launchtemplate.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}


