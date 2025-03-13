output "iam_group_names" {
  value = tomap({
    for k, v in aws_iam_group.main : k => v.name
  })
}
