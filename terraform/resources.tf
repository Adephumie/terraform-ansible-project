# This tf file will help to create the three VMs in the public subnets
# they are attached to, Elastic IPs attached to them, Application Load
# Balancer, Target Groups for ALB, attachment of the VMs to the target
# group created, HTTP and HTTPS listeners.


# Create the first EC2 instance in pub_subnet_B
resource "aws_instance" "webserver_1" {
  ami                         = var.ami_value
  instance_type               = var.vm_type
  availability_zone           = var.availability_zone_A
  associate_public_ip_address = true
  key_name                    = aws_key_pair.instance_key_pair.key_name
  subnet_id                   = aws_subnet.pub_subnet_B.id

  tags = {
    Name = "webserver-1"
  }
}

# Create the second EC2 instance in pub_subnet_C
resource "aws_instance" "webserver_2" {
  ami                         = var.ami_value
  instance_type               = var.vm_type
  availability_zone           = var.availability_zone_B
  associate_public_ip_address = true
  key_name                    = aws_key_pair.instance_key_pair.key_name
  subnet_id                   = aws_subnet.pub_subnet_C.id

  tags = {
    Name = "webserver-2"
  }
}

# Create the third EC2 instance in pub_subnet_D
resource "aws_instance" "webserver_3" {
  ami                         = var.ami_value
  instance_type               = var.vm_type
  availability_zone           = var.availability_zone_B
  associate_public_ip_address = true
  key_name                    = aws_key_pair.instance_key_pair.key_name
  subnet_id                   = aws_subnet.pub_subnet_D.id

  tags = {
    Name = "webserver-3"
  }
}

# Create Elastic IP for webserver-1
resource "aws_eip" "webserver_1_ip" {
  vpc        = true
  instance   = aws_instance.webserver_1.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "webserver-1-ip"
  }
}

# Create Elastic IP for webserver-2
resource "aws_eip" "webserver_2_ip" {
  vpc        = true
  instance   = aws_instance.webserver_2.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "webserver-2-ip"
  }
}

# Create Elastic IP for webserver-3
resource "aws_eip" "webserver_3_ip" {
  vpc        = true
  instance   = aws_instance.webserver_3.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "webserver-3-ip"
  }
}

# Create Application Load Balancer in pub_subnet_A
resource "aws_lb" "project_lb" {
  name                       = "project-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_bal_SG.id]
  subnets                    = [aws_subnet.pub_subnet_B.id, aws_subnet.pub_subnet_C.id, aws_subnet.pub_subnet_C.id]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false
  depends_on                 = [aws_instance.webserver_1, aws_instance.webserver_2, aws_instance.webserver_3]

  tags = {
    Environment = "production"
  }
}

# Create Target Groups for Application LB
resource "aws_lb_target_group" "project_target_group" {
  name     = "project-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

# Create target group attachment for webserver 1
resource "aws_lb_target_group_attachment" "web_1_tg_attach" {
  target_group_arn = aws_lb_target_group.project_target_group.arn
  target_id        = aws_instance.webserver_1.id
  port             = 80
}

# Create target group attachment for webserver 2
resource "aws_lb_target_group_attachment" "web_2_tg_attach" {
  target_group_arn = aws_lb_target_group.project_target_group.arn
  target_id        = aws_instance.webserver_2.id
  port             = 80
}

# Create target group attachment for webserver 3
resource "aws_lb_target_group_attachment" "web_3_tg_attach" {
  target_group_arn = aws_lb_target_group.project_target_group.arn
  target_id        = aws_instance.webserver_3.id
  port             = 80
}

# Create HTTP listener to forward load balancer requests to target group
resource "aws_lb_listener" "http_lb_listener" {
  load_balancer_arn = aws_lb.project_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_target_group.arn
  }
}

# Create HTTPS listener for ALB requests 
resource "aws_lb_listener" "https_lb_listener" {
  load_balancer_arn = aws_lb.project_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_target_group.arn
  }
}

# Create a redirect of HTTP to HTTPS
resource "aws_lb_listener" "http_to_https" {
  load_balancer_arn = aws_lb.project_lb.arn
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

# Create a Load Balancer Listener Certificate
resource "aws_lb_listener_certificate" "project_lb_list_cert" {
  listener_arn    = aws_lb_listener.http_lb_listener.arn
  certificate_arn = var.ssl_certificate_arn
}




