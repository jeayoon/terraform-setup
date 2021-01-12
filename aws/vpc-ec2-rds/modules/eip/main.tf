#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}
variable "ec2_instance_id" {}


#--------------------------------------------------------------
# EC2 EIP Settings
#--------------------------------------------------------------
resource "aws_eip" "ec2" {
  instance  = var.ec2_instance_id
  vpc       = true
  tags      = {
    Name = "${var.account_name}-${var.env}-ec2-eip"
  }
}
