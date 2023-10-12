#--------------------------------------------------------------
# VPC
#--------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags       = merge(var.tags, { "Name" = "vpc-fargate-cicd" })
}

#--------------------------------------------------------------
# Subnet
#--------------------------------------------------------------
resource "aws_subnet" "prv_a1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 0) // 10.0.0.0/24
  availability_zone = "${var.region}a"
  tags              = merge(var.tags, { "Name" = "prv-sub-a1" })
}
resource "aws_subnet" "prv_c1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 2) // 10.0.2.0/24
  availability_zone = "${var.region}c"
  tags              = merge(var.tags, { "Name" = "prv-sub-c1" })
}

resource "aws_subnet" "pub_a1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1) // 10.0.1.0/24
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "Name" = "pub-sub-a1" })
}
resource "aws_subnet" "pub_c1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 3) // 10.0.3.0/24
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { "Name" = "pub-sub-c1" })
}

#--------------------------------------------------------------
# Internet Gateway
#--------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "igw-fargate-cicd" })
}

#--------------------------------------------------------------
# Elastic IP
#--------------------------------------------------------------
resource "aws_eip" "ngw1" {
  vpc  = true
  tags = merge(var.tags, { "Name" = "eip-ngw1" })
}


resource "aws_eip" "ngw2" {
  vpc  = true
  tags = merge(var.tags, { "Name" = "eip-ngw2" })
}

#--------------------------------------------------------------
# NAT Gateway
#--------------------------------------------------------------
resource "aws_nat_gateway" "a1" {
  allocation_id = aws_eip.ngw1.id
  subnet_id     = aws_subnet.pub_a1.id
  depends_on    = [aws_internet_gateway.main]
  tags          = merge(var.tags, { "Name" = "ngw1" })
}
resource "aws_nat_gateway" "c1" {
  allocation_id = aws_eip.ngw2.id
  subnet_id     = aws_subnet.pub_c1.id
  depends_on    = [aws_internet_gateway.main]
  tags          = merge(var.tags, { "Name" = "ngw2" })
}

#--------------------------------------------------------------
# Route Table
#--------------------------------------------------------------
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "rt-igw" })
}
resource "aws_route" "igw" {
  route_table_id         = aws_route_table.igw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
resource "aws_route_table_association" "igw1" {
  subnet_id      = aws_subnet.pub_a1.id
  route_table_id = aws_route_table.igw.id
}
resource "aws_route_table_association" "igw2" {
  subnet_id      = aws_subnet.pub_c1.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table" "ngw1" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "rt-ngw1" })
}
resource "aws_route" "ngw1" {
  route_table_id         = aws_route_table.ngw1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.a1.id
}
resource "aws_route_table_association" "ngw1" {
  subnet_id      = aws_subnet.prv_a1.id
  route_table_id = aws_route_table.ngw1.id
}

resource "aws_route_table" "ngw2" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "rt-ngw2" })
}
resource "aws_route" "ngw2" {
  route_table_id         = aws_route_table.ngw2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.c1.id
}
resource "aws_route_table_association" "ngw2" {
  subnet_id      = aws_subnet.prv_c1.id
  route_table_id = aws_route_table.ngw2.id
}

#--------------------------------------------------------------
# Security Group
#--------------------------------------------------------------

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "sg-alb" })
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "allow_app_sg_outbound" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.app.id
}

resource "aws_security_group" "app" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "sg-app" })
}
resource "aws_security_group_rule" "allow_alb_sg_inbound" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
}
resource "aws_security_group_rule" "allow_every_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.app.id
  cidr_blocks       = ["0.0.0.0/0"]
}
