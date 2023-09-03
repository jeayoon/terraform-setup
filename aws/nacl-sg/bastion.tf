# EC2
resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-eip"
  }
}

resource "aws_instance" "bastion" {
  ami = "${var.bastion_ami}"
  instance_type = "${var.bastion_instance_type}"
  vpc_security_group_ids = [aws_security_group.bastion_ec2.id]
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  subnet_id = aws_subnet.public1.id
  key_name = data.aws_key_pair.ec2.key_name
  disable_api_termination = true
  root_block_device {
    volume_size = "${var.bastion_volume_size}"
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.project_name}-${var.environment}-bastion-ec2"
    }
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-ec2"
  }
}