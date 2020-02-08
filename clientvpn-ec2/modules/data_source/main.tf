#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "client_domain" {}

#--------------------------------------------------------------
# AWS ACM Certificate Settings (import aws acm before terraform deploy)
#--------------------------------------------------------------
data "aws_acm_certificate" "server_certificate" {
  domain = "server"
}

data "aws_acm_certificate" "client_certificate" {
  domain = var.client_domain
}