#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "vpc_id" {}
variable "account_name" {}
variable "my_global_id" {}

#--------------------------------------------------------------
# Security Group Settings (EC2)
#--------------------------------------------------------------
resource "aws_security_group" "ec2" {
    name = "${var.account_name}-${var.env}-ec2-sg"
    vpc_id = var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [var.my_global_id]
        description = "Connect SSH"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [var.my_global_id]
        description = "Connect http"
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

#--------------------------------------------------------------
# Security Group Settings (RDS)
#--------------------------------------------------------------
resource "aws_security_group" "rds" {
    name = "${var.account_name}-${var.env}-rds-sg"
    vpc_id = var.vpc_id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.ec2.id]
        description = "EC2 SG"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.account_name}-${var.env}-rds-sg"
    }
}