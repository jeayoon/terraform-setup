#--------------------------------------------------------------
# module
#--------------------------------------------------------------

# IAM User
module "iam_user" {
  source = "../../modules/multi_user/iam_user"
  map    = local.iam_user_map
}

# IAM Group
module "iam_group" {
  source = "../../modules/multi_user/iam_group"
  map    = local.iam_group_map
}

# IAM Group
module "iam_policy" {
  source = "../../modules/multi_user/iam_policy"
  map    = local.iam_policy_map

  depends_on = [module.iam_group]
}
