#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "vpc_id" {}
variable "account_name" {}
variable "s3_service_name" {}
variable "private_route_table_id" {}

#--------------------------------------------------------------
#  VPC Endpoint Settings
#--------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = var.s3_service_name
  route_table_ids = [var.private_route_table_id]

  tags = {
    Name = "${var.account_name}-${var.env}-s3-vpc-endpoint"
  }
}