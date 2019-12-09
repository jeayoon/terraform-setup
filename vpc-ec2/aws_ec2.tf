#--------------------------------------------------------------
# resource Launch Configuration(業務管理)
#--------------------------------------------------------------
resource "aws_instance" "main" {
  ami                         = var.ec2_launch_ami
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.sshkey.key_name
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = ["${aws_security_group.main.id}"]
  associate_public_ip_address = "true"

  tags = {
    Name = "${var.app_name}-ec2"
  }
}