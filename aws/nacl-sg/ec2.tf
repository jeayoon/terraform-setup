# EC2
resource "aws_instance" "private-ec2" {
  ami = "${var.Private_EC2_ami}"
  instance_type = "${var.Private_EC2_instance_type}"
  vpc_security_group_ids = [aws_security_group.private_ec2.id]
  iam_instance_profile = aws_iam_instance_profile.private_ec2.name
  subnet_id = aws_subnet.private1.id
  associate_public_ip_address = false
  key_name = data.aws_key_pair.ec2.key_name
  disable_api_termination = true
  root_block_device {
    volume_size = "${var.Private_EC2_volume_size}"
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.project_name}-${var.environment}-private-ec2"
    }
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-private-ec2"
  }
}