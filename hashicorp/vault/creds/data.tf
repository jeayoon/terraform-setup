data "aws_ssm_parameter" "token" {
  name = "/dev/vault/token"
}

data "aws_ssm_parameter" "access_key" {
  name = "/dev/vault/aws_access_key_id"
}

data "aws_ssm_parameter" "secret_key" {
  name = "/dev/vault/aws_secret_access_key"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
  }
}

data "aws_caller_identity" "this" {}

data "aws_iam_policy" "policy" {
  name = "AdministratorAccess"
}
