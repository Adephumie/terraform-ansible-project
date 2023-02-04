# This tf file creates the VPC, Internet Gateway, subnets, route tables,
# key pairs, and security groups for VMs and ALB.

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-project-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "vpc-igw"
  }
}

# Create the first public subnet
resource "aws_subnet" "pub_subnet_A" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_A_cidr_block
  availability_zone = var.availability_zone_A

  tags = {
    Name = "public-subnet-A"
  }
}

# Create the second public subnet
resource "aws_subnet" "pub_subnet_B" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_B_cidr_block
  availability_zone = var.availability_zone_A

  tags = {
    Name = "public-subnet-B"
  }
}

# Create the third public subnet
resource "aws_subnet" "pub_subnet_C" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_C_cidr_block
  availability_zone = var.availability_zone_B

  tags = {
    Name = "public-subnet-C"
  }
}

# Create the fourth public subnet
resource "aws_subnet" "pub_subnet_D" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_D_cidr_block
  availability_zone = var.availability_zone_B

  tags = {
    Name = "public-subnet-D"
  }
}

# Create Route table for public subnets
resource "aws_route_table" "pub-Route-T" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-RT"
  }
}

# Associate pub_subnet_A to the public Route table
resource "aws_route_table_association" "pub_subnet_A_association" {
  subnet_id      = aws_subnet.pub_subnet_A.id
  route_table_id = aws_route_table.pub-Route-T.id
}

# Associate pub_subnet_B to the public Route table
resource "aws_route_table_association" "pub_subnet_B_association" {
  subnet_id      = aws_subnet.pub_subnet_B.id
  route_table_id = aws_route_table.pub-Route-T.id
}

# Associate pub_subnet_C to the public Route table
resource "aws_route_table_association" "pub_subnet_C_association" {
  subnet_id      = aws_subnet.pub_subnet_C.id
  route_table_id = aws_route_table.pub-Route-T.id
}

# Associate pub_subnet_D to the public Route table
resource "aws_route_table_association" "pub_subnet_D_association" {
  subnet_id      = aws_subnet.pub_subnet_D.id
  route_table_id = aws_route_table.pub-Route-T.id
}

# Create Security Group for allowing TCP/80, TCP/22, and TCP/443 on the VMs
resource "aws_security_group" "vm_security_group" {
  name        = "vm_security_group"
  description = "Allow inbound TCP/80, TCP/443, and TCP/22 traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description     = "Allow HTTP traffic from TCP/80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_bal_SG.id]
  }

  ingress {
    description     = "Allow HTTPS traffic"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.load_bal_SG.id]
  }

  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "webserver-SG"
  }
}

# Create Load Balancer Security Group
resource "aws_security_group" "load_bal_SG" {
  name        = "load_bal_SG"
  description = "Allow TCP/80, TCP/443, and traffic from EC2 instances SG"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load-balancer-SG"
  }
}



