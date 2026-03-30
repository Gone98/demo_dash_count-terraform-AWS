#################################################################
#VPC
#################################################################

resource "aws_vpc" "dashboard_counting_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.instance_tenancy

  tags = {
    terraform = "true"
  }
}

#################################################################
#Subnets
#################################################################

resource "aws_subnet" "dashboard_subnet" {
  vpc_id                  = aws_vpc.dashboard_counting_vpc.id
  cidr_block              = var.dashboard_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    terraform = "true"
  }
}

resource "aws_subnet" "counting_subnet" {
  vpc_id     = aws_vpc.dashboard_counting_vpc.id
  cidr_block = var.counting_subnet_cidr

  tags = {
    terraform = "true"
  }
}

################################################################
#Internet Gateway and NAT Gateway
################################################################

resource "aws_internet_gateway" "dashboard_igw" {
  vpc_id = aws_vpc.dashboard_counting_vpc.id

  tags = {
    terraform = "true"
  }
}

resource "aws_nat_gateway" "counting_nat_gw" {
  allocation_id = aws_eip.counting_eip.id
  subnet_id     = aws_subnet.dashboard_subnet.id

  tags = {
    terraform = "true"
  }
}

resource "aws_eip" "counting_eip" {
  domain = "vpc"

  tags = {
    terraform = "true"
  }
}

################################################################
#Route Tables
################################################################

resource "aws_route_table" "dashboard_route_table" {
  vpc_id = aws_vpc.dashboard_counting_vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = var.any_cidr
    gateway_id = aws_internet_gateway.dashboard_igw.id
  }
}

resource "aws_route_table" "counting_route_table" {
  vpc_id = aws_vpc.dashboard_counting_vpc.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block     = var.any_cidr
    nat_gateway_id = aws_nat_gateway.counting_nat_gw.id
  }
}

resource "aws_route_table_association" "dashboard_route_table_association" {
  subnet_id      = aws_subnet.dashboard_subnet.id
  route_table_id = aws_route_table.dashboard_route_table.id
}

resource "aws_route_table_association" "counting_route_table_association" {
  subnet_id      = aws_subnet.counting_subnet.id
  route_table_id = aws_route_table.counting_route_table.id
}

################################################################
#Security Groups
################################################################


resource "aws_security_group" "dashboard_sg" {
  name   = var.dashboard_sg_name
  vpc_id = aws_vpc.dashboard_counting_vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.any_cidr]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.any_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.any_cidr]
    prefix_list_ids = []
  }

}

resource "aws_security_group" "counting_sg" {
  name   = var.counting_sg_name
  vpc_id = aws_vpc.dashboard_counting_vpc.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.any_cidr]
    prefix_list_ids = []
  }

}
