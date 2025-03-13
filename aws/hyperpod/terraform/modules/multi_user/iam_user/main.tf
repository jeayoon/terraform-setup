#--------------------------------------------------------------
# Variable Setting
#--------------------------------------------------------------
variable "map" {}

#--------------------------------------------------------------
# IAM User
#--------------------------------------------------------------
resource "aws_iam_user" "main" {
  for_each = var.map

  name = each.value.name

  tags = {
    name              = each.value.name
    "SSMSessionRunAs" = each.value.ssm_run_as # For access to Hyperpod
  }
}

resource "aws_iam_access_key" "main" {
  for_each = var.map

  user = aws_iam_user.main[each.key].name
}
