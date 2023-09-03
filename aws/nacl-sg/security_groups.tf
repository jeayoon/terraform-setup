# Security Group
# Bastion EC2 SG
resource "aws_security_group" "bastion_ec2"{
    name        = "${var.project_name}-${var.environment}-bastion-sg"
    description = "for bastion ec2"
    vpc_id      = aws_vpc.vpc.id

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-sg"
  }
}

# Private EC2 SG
resource "aws_security_group" "private_ec2"{
    name        = "${var.project_name}-${var.environment}-private-sg"
    description = "for private ec2"
    vpc_id      = aws_vpc.vpc.id

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-sg"
  }
}

resource "aws_security_group_rule" "private_ec2" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_ec2.id
  security_group_id        = aws_security_group.private_ec2.id
}