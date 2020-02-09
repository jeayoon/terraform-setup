#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "vpc_id" {}
variable "account_name" {}
variable "segment1_az" {}
variable "segment2_az" {}
variable "app_public_segment1" {}
variable "db_private_segment1" {}
variable "db_private_segment2" {}

#--------------------------------------------------------------
# Subnets Settings
#--------------------------------------------------------------

#App Subnet
resource "aws_subnet" "app_subnet1" {
    vpc_id = var.vpc_id
    cidr_block = var.app_public_segment1
    availability_zone = var.segment1_az
    tags = {
        Name = "${var.account_name}-${var.env}-app-subnet"
    }
}

#RDS Subnet
resource "aws_subnet" "db_subnet1" {
    vpc_id = var.vpc_id
    cidr_block = var.db_private_segment1
    availability_zone = var.segment1_az
    tags = {
        Name = "${var.account_name}-${var.env}-db-subnet1"
    }
}
resource "aws_subnet" "db_subnet2" {
    vpc_id = var.vpc_id
    cidr_block = var.db_private_segment2
    availability_zone = var.segment2_az
    tags = {
        Name = "${var.account_name}-${var.env}-db-subnet2"
    }
}