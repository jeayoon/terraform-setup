#--------------------------------------------------------------
# Variable Setting
#--------------------------------------------------------------
variable "map" {}

#--------------------------------------------------------------
# IAM Group
#--------------------------------------------------------------
resource "aws_iam_group" "main" {
  for_each = var.map

  name = each.value.name
}

resource "aws_iam_group_membership" "main" {
  for_each = var.map

  name  = each.value.membership_name
  users = each.value.users
  group = aws_iam_group.main[each.key].name
}
