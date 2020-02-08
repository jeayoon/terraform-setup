#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}

#--------------------------------------------------------------
# Instance Role and Policy
#--------------------------------------------------------------

data "template_file" "ec2_assume" {
  template = file("${path.module}/files/ec2/assume.json.tpl")
}
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.account_name}-${var.env}-instance-role"
  path = "/"

  assume_role_policy = data.template_file.ec2_assume.rendered
}

data "template_file" "ec2_instance_policy" {
  template = file("${path.module}/files/s3/full_access.json.tpl")
}
resource "aws_iam_role_policy" "ec2_instance_policy" {
  name   = "${var.account_name}-${var.env}-instance-policy"
  role   = aws_iam_role.ec2_instance_role.id

  policy = data.template_file.ec2_instance_policy.rendered
}