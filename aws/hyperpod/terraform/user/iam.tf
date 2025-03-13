# IAM User用
resource "aws_iam_policy" "ssm_access_policy" {
  name   = join("-", [var.project_name, var.env, "Sagemaker-SSM-Access-policy"])
  policy = templatefile("${path.module}/files/sagemaker_ssm_access_policy.json.tpl", {})
}
