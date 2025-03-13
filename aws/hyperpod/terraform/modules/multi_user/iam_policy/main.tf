#--------------------------------------------------------------
# Variable Setting
#--------------------------------------------------------------
variable "map" {}

#--------------------------------------------------------------
# IAM Policy
#--------------------------------------------------------------
resource "aws_iam_group_policy_attachment" "attach_ssm_access" {
  for_each = var.map

  policy_arn = each.value.policy_arn
  group      = each.value.group_name
}

resource "aws_iam_group_policy_attachment" "s3_full_access" {
  for_each = var.map

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  group      = each.value.group_name
}
