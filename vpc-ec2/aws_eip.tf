#--------------------------------------------------------------
# EIP Settings
#--------------------------------------------------------------
resource "aws_eip" "main" {
  instance  = aws_instance.main.id
  vpc       = true
  tags      = {
    Name = "${var.app_name}-eip"
  }
}