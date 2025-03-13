#--------------------------------------------------------------
# Security Group
#--------------------------------------------------------------
resource "aws_security_group" "efa_sg" {
  name   = join("-", [var.project_name, var.env, "efa_sg"])
  vpc_id = aws_vpc.main.id

  tags = {
    Name = join("-", [var.project_name, var.env, "efa_sg"])
  }
}

resource "aws_security_group_rule" "efa_sg_ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efa_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "efa_sg_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.efa_sg.id
  source_security_group_id = aws_security_group.efa_sg.id
}
resource "aws_security_group_rule" "efa_sg_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efa_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "efa_sg_egress_self" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.efa_sg.id
  source_security_group_id = aws_security_group.efa_sg.id
}
