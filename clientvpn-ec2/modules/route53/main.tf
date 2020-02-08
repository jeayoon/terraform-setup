#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}
variable "client_domain" {}
variable "ec2_private_id" {}

#--------------------------------------------------------------
# Route53 Settings
#--------------------------------------------------------------
resource "aws_route53_zone" "main" {
    name = var.client_domain
}

resource "aws_route53_record" "main" {
    zone_id = aws_route53_zone.main.id
    name    = var.client_domain
    type    = "A"
    ttl     = "30"
    records = [var.ec2_private_id]
}