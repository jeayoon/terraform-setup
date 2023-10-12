data "aws_caller_identity" "current" {}

locals {
  container_image = "${aws_ecr_repository.main.repository_url}:latest"
  account_id      = data.aws_caller_identity.current.account_id
}
