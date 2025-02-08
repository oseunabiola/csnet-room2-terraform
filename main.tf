# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.main_vpc_cidr_block

  tags = {
    Name = var.main_vpc_name
  }
}

# 4 subnets
resource "aws_subnet" "pub_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.pub_subnet1_cidr_block
  availability_zone = var.subnet1_az
  tags = {
    Name = var.pub_subnet1_name
  }
}

resource "aws_subnet" "priv_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.priv_subnet1_cidr_block
  availability_zone = var.subnet1_az
  tags = {
    Name = var.priv_subnet1_name
  }
}

resource "aws_subnet" "pub_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.pub_subnet2_cidr_block
  availability_zone = var.subnet2_az
  tags = {
    Name = var.pub_subnet2_name
  }
}

resource "aws_subnet" "priv_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.priv_subnet2_cidr_block
  availability_zone = var.subnet2_az
  tags = {
    Name = var.priv_subnet2_name
  }
}

# 2 route tables
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = var.pub_route_table_name
  }
  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gw.id
  }

  tags = {
    Name = var.priv_route_table_name
  }

  depends_on = [aws_nat_gateway.main_nat_gw]
}

# 1 internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.main_igw_name
  }
}

# 1 NAT gateway
resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.main_eip.id #TODO: Create an Elastic IP
  subnet_id     = aws_subnet.pub_subnet2.id

  tags = {
    Name = var.main_nat_gw_name
  }

  depends_on = [aws_eip.main_eip]
}

# 1 Elastic IP
resource "aws_eip" "main_eip" {
  domain = "vpc"

  tags = {
    Name = var.main_eip_name
  }
}

# 1 route table association
resource "aws_route_table_association" "pub_subnet1_association" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "priv_subnet1_association" {
  subnet_id      = aws_subnet.priv_subnet1.id
  route_table_id = aws_route_table.priv_route_table.id
}

resource "aws_route_table_association" "pub_subnet2_association" {
  subnet_id      = aws_subnet.pub_subnet2.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "priv_subnet2_association" {
  subnet_id      = aws_subnet.priv_subnet2.id
  route_table_id = aws_route_table.priv_route_table.id
}

# 2 Security Group
resource "aws_security_group" "priv_sg" {
  name        = var.sg_priv_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = var.sg_priv_name
  }
}

resource "aws_security_group" "pub_sg" {
  name        = var.sg_pub_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = var.sg_pub_name
  }
}

# Security group rule
resource "aws_vpc_security_group_ingress_rule" "tomcat_port" {
  security_group_id = aws_security_group.priv_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "ssh_port" {
  security_group_id = aws_security_group.priv_sg.id

  cidr_ipv4   = var.priv_subnet1_cidr_block
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.priv_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


# S3 bucket
# 