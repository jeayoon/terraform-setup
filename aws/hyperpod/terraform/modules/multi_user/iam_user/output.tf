output "names" {
  value = tomap({
    for k, v in aws_iam_user.main : k => v.name
  })
}

output "aws_iam_access_keys" {
  value = tomap({
    for k, v in aws_iam_access_key.main : k => {
      id     = v.id
      secret = v.secret
    }
  })
  sensitive = true
}
