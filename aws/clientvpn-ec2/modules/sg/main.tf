#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}
variable "vpc_id" {}
variable "root_segment" {}
variable "my_global_id" {}
variable "customer_global_ip" {}
variable "client_vpn_sg" {}
variable "client_vpn_segment" {}

#--------------------------------------------------------------
# Security Group Settings (EC2)
#--------------------------------------------------------------
resource "aws_security_group" "ec2" {
    name = "${var.account_name}-${var.env}-ec2-sg"
    vpc_id = var.vpc_id
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        security_groups = [aws_security_group.client_vpn.id]
        description = "Connect with ClientVPN SG"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.client_vpn.id]
        description = "Connect with ClientVPN SG for SSH"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.client_vpn.id]
        description = "Connect with ClientVPN SG for http"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.account_name}-${var.env}-ec2-sg"
    }
}

resource "aws_security_group" "client_vpn" {
    name = "${var.account_name}-${var.env}-client-vpn-sg"
    vpc_id = var.vpc_id
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [var.root_segment]
        description = "Connect ClientVPN"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.root_segment]
        description = "SSH"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.root_segment]
        description = "http"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.account_name}-${var.env}-client-vpn-sg"
    }
}