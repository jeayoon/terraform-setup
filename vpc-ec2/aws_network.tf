#--------------------------------------------------------------
# VPC Settings
#--------------------------------------------------------------
resource "aws_vpc" "main" {
    cidr_block = var.root_segment
    tags = {
        Name = "${var.app_name}-vpc"
    }
}

#--------------------------------------------------------------
# Internet Gateway Settings
#--------------------------------------------------------------
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.app_name}-igw"
    }
}

#--------------------------------------------------------------
# Public Subnets Settings
#--------------------------------------------------------------
#ec2(gyomu)
resource "aws_subnet" "main" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.ec2_public_segment1
    availability_zone = var.public_segment1_az
    tags = {
        Name = "${var.app_name}-ec2-subnet"
    }
}

#--------------------------------------------------------------
# Routes Table Settings (Public)
#--------------------------------------------------------------

resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "${var.app_name}-public-rt"
    }
}

resource "aws_route_table_association" "main" {
    subnet_id = aws_subnet.main.id
    route_table_id = aws_route_table.main.id
}

