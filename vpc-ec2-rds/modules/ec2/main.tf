#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "ami" {}
variable "env" {}
variable "ssh_pub" {}
variable "ec2_sg_id" {}
variable "account_name" {}
variable "instance_type" {}
variable "app_subnet1_id" {}
variable "ec2_instance_role_name" {}


#--------------------------------------------------------------
# EC2 Settings
#--------------------------------------------------------------
resource "aws_instance" "main" {
    ami                         = var.ami
    instance_type               = var.instance_type
    vpc_security_group_ids      = [var.ec2_sg_id]
    subnet_id                   = var.app_subnet1_id
    key_name                    = aws_key_pair.sshkey.key_name
    associate_public_ip_address = true
    disable_api_termination     = "true"

    tags = {
        Name = "${var.account_name}-${var.env}-ec2"
    }
}

#--------------------------------------------------------------
# KeyPair Settings
#--------------------------------------------------------------
resource "aws_key_pair" "sshkey" {
    key_name = "${var.account_name}-${var.env}-keypair"
    public_key = var.ssh_pub
}
