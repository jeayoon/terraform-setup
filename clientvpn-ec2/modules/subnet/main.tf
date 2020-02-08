#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}
variable "vpc_id" {}
variable "nat_public_segment" {}
variable "app_private_segment1" {}
variable "segment1_az" {}


#--------------------------------------------------------------
# Subnets Settings
#--------------------------------------------------------------

#Nat Gatway Subnet
resource "aws_subnet" "nat_subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.nat_public_segment
    availability_zone = var.segment1_az
    tags = {
        Name = "${var.account_name}-${var.env}-nat-subnet"
    }
}

#App Subnet
resource "aws_subnet" "app_subnet1" {
    vpc_id = var.vpc_id
    cidr_block = var.app_private_segment1
    availability_zone = var.segment1_az
    tags = {
        Name = "${var.account_name}-${var.env}-app-subnet"
    }
}