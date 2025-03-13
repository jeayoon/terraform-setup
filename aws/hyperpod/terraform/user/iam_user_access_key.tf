# IAM User AccessKey
# resource "local_file" "main" {
#   for_each = module.iam_user.aws_iam_access_keys

#   content  = "access_key,secret_key\n${each.value.id},${each.value.secret}"
#   filename = pathexpand("${var.access_key_dir}/${var.env}/${each.key}/${join("-", [var.project_name, var.env, each.key, "access", "key"])}.csv")

#   lifecycle {
#     prevent_destroy = true
#     ignore_changes  = [content]
#   }
# }

# IAM User AccessKey
resource "local_file" "main" {
  for_each = {
    for key, value in module.iam_user.aws_iam_access_keys : key => {
      access_key = value.id
      secret_key = value.secret
      user_info  = [for user in local.user_csv_data : user if user.User == key][0]
    }
    if contains([for user in local.user_csv_data : user.User], key)
  }

  content  = "access_key,secret_key,os_username,os_password\n${each.value.access_key},${each.value.secret_key},${each.value.user_info.User},${each.value.user_info.Password}"
  filename = pathexpand("${var.access_key_dir}/${var.env}/${each.key}/${join("-", [var.project_name, var.env, each.key, "access", "key"])}.csv")

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [content]
  }
}
