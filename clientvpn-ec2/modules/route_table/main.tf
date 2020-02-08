#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "vpc_id" {}
variable "env" {}
variable "account_name" {}
variable "nat_eip_id" {}
variable "nat_subnet_id" {}
variable "app_subnet1_id" {}

#--------------------------------------------------------------
# Internet Gateway Settings
#--------------------------------------------------------------
resource "aws_internet_gateway" "main" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.account_name}-${var.env}-igw"
    }
}

#--------------------------------------------------------------
# Route Table Settings
#--------------------------------------------------------------
# Route table for applications subnet
resource "aws_route_table" "private_rt" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.account_name}-${var.env}-private-route-table"
    }
}

# create an association between a app subnet and private routing table.
resource "aws_route_table_association" "app_rta1" {
    subnet_id = var.app_subnet1_id
    route_table_id = aws_route_table.private_rt.id
}

# Route table for nat gateway
resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.account_name}-${var.env}-public-route-table"
    }
}

#--------------------------------------------------------------
# Nat Gateway Settings
#--------------------------------------------------------------
# Create Nat gateway
resource "aws_nat_gateway" "main" {
    allocation_id = var.nat_eip_id
    subnet_id     = var.nat_subnet_id

    tags = {
        Name = "${var.account_name}-${var.env}-nat-gateway"
    }
}

# create an association between a Nat gateway subnet and public routing table.
resource "aws_route_table_association" "nat_as" {
  subnet_id      = var.nat_subnet_id
  route_table_id = aws_route_table.public_rt.id
}

# Connect nat gateway to app private route table
resource "aws_route" "nat_app_rt" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_rt.id
  nat_gateway_id         = aws_nat_gateway.main.id
}