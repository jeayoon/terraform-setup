#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}


#--------------------------------------------------------------
# Client VPN Log Group
#--------------------------------------------------------------
resource "aws_cloudwatch_log_group" "client_vpn_log_group" {
    name = "${var.account_name}-${var.env}-client-vpn-logs"
    retention_in_days = 180

    tags = {
        Environment = var.env
        Application = "${var.account_name}-${var.env}-client-vpn-logs"
    }
}

resource "aws_cloudwatch_log_stream" "client_vpn_log_stream" {
  name           = "${var.account_name}-${var.env}-client-vpn-log"
  log_group_name = aws_cloudwatch_log_group.client_vpn_log_group.name
}