#--------------------------------------------------------------
# Network
#--------------------------------------------------------------

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = join("-", [var.project_name, var.env, "vpc"])
  }
}

# Addition VPC CIDR
resource "aws_vpc_ipv4_cidr_block_association" "cidr_block" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_block2
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = join("-", [var.project_name, var.env, "igw"])
  }
}

# Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = join("-", [var.project_name, var.env, "eip01"])
  }
}

# NAT
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public02.id

  tags = {
    Name = join("-", [var.project_name, var.env, "ngw"])
  }
}

# Public Subnet
resource "aws_subnet" "public01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 2, 0)
  map_public_ip_on_launch = true
  availability_zone_id    = var.tokyo_az_1a_zone_id

  tags = {
    Name = join("-", [var.project_name, var.env, "public", "subnet", "1a"])
  }
}
resource "aws_subnet" "public02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 2, 1)
  map_public_ip_on_launch = true
  availability_zone_id    = var.tokyo_az_1c_zone_id

  tags = {
    Name = join("-", [var.project_name, var.env, "public", "subnet", "1c"])
  }
}

# Private Subnet
resource "aws_subnet" "private01" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = cidrsubnet(aws_vpc_ipv4_cidr_block_association.cidr_block.cidr_block, 2, 0)
  availability_zone_id = var.tokyo_az_1a_zone_id

  tags = {
    Name = join("-", [var.project_name, var.env, "private", "subnet", "1a"])
  }
}

# Privates Subnet
resource "aws_subnet" "private02" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = cidrsubnet(aws_vpc_ipv4_cidr_block_association.cidr_block.cidr_block, 2, 1)
  availability_zone_id = var.tokyo_az_1c_zone_id

  tags = {
    Name = join("-", [var.project_name, var.env, "private", "subnet", "1c"])
  }
}

# Route Table IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = join("-", [var.project_name, var.env, "public", "rtb"])
  }
}

# Route Table NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = join("-", [var.project_name, var.env, "private", "rtb"])
  }
}

# Route Table Assoc Public Subnet
resource "aws_route_table_association" "public01_association" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.public.id
}
# Route Table Assoc Public Subnet
resource "aws_route_table_association" "public02_association" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.public.id
}

# Route Table Assoc Private Subnet
resource "aws_route_table_association" "private01_association" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.private.id
}
# Route Table Assoc Private Subnet
resource "aws_route_table_association" "private02_association" {
  subnet_id      = aws_subnet.private02.id
  route_table_id = aws_route_table.private.id
}

# S3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = [
    aws_route_table.public.id,
    aws_route_table.private.id
  ]
}
