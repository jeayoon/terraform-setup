# for modules
locals {
  module_iam_user_names = module.iam_user.names

  user_csv_data = csvdecode(templatefile("${path.module}/files/user_info.csv", {}))

  iam_user_map = {
    for user in local.user_csv_data : user.User => {
      name       = join("-", [var.project_name, var.env, user.User])
      ssm_run_as = user.User
    }
  }

  iam_group_map = {
    for group_name in distinct([for user in local.user_csv_data : user.Group]) : group_name => {
      name            = join("-", [var.project_name, var.env, group_name])
      users           = [for user in local.user_csv_data : local.module_iam_user_names[user.User] if user.Group == group_name]
      membership_name = join("-", [var.project_name, var.env, group_name, "membership"])
    }
  }

  iam_policy_map = {
    for group_name in distinct([for user in local.user_csv_data : user.Group]) : group_name => {
      group_name = join("-", [var.project_name, var.env, group_name])
      policy_arn = aws_iam_policy.ssm_access_policy.arn
    }
  }
}
