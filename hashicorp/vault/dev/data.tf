data "vault_aws_access_credentials" "aws" {
  backend = "aws"
  role    = "dev-vault-role"
  type    = "sts"
}
