#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "vpc_id" {}
variable "account_name" {}
variable "db_subnet1_id" {}
variable "db_subnet2_id" {}
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

# create an association between a db subnet and private routing table.
resource "aws_route_table_association" "db_rta1" {
    subnet_id = var.db_subnet1_id
    route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "db_rta2" {
    subnet_id = var.db_subnet2_id
    route_table_id = aws_route_table.private_rt.id
}

# public route table
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

# create an association between a app subnet and public routing table.
resource "aws_route_table_association" "app_rta1" {
    subnet_id = var.app_subnet1_id
    route_table_id = aws_route_table.public_rt.id
}
