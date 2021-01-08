#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}
variable "nat_subnet_id" {}
variable "app_subnet1_id" {}
variable "client_cidr_block" {}
variable "server_certificate_arn" {}
variable "client_certificate_arn" {}
variable "client_vpn_log_group_name" {}
variable "client_vpn_log_stream_name" {}


#--------------------------------------------------------------
#  EIP Settings
#--------------------------------------------------------------
resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "${var.account_name}-${var.env}-client-vpn"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_certificate_arn
  }
  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = var.client_vpn_log_group_name
    cloudwatch_log_stream = var.client_vpn_log_stream_name
  }
  tags = {
    Name = "${var.account_name}-${var.env}-client-vpn"
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = var.app_subnet1_id
}