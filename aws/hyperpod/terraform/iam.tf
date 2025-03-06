#--------------------------------------------------------------
# IAM
#--------------------------------------------------------------

#-------------------------------
# IAM Role: Sagemaker Hyperpod
#-------------------------------
resource "aws_iam_role" "sagemaker_execution_role" {
  name               = join("-", [var.project_name, var.env, "SagemakerHyperpod-Role"])
  assume_role_policy = templatefile("${path.module}/files/assumerole.json.tpl", { resource = "sagemaker" })
}

resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "attach_sagemaker_cluster_instance" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerClusterInstanceRolePolicy"
}

resource "aws_iam_role_policy_attachment" "attach_ssm_managed" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "attach_sagemeker_full_access" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_policy" "sagemeker_auto_resume" {
  name   = join("-", [var.project_name, var.env, "Sagemaker-AutoResume-policy"])
  policy = templatefile("${path.module}/files/sagemaker_auto_resume_policy.json.tpl", {})
}

resource "aws_iam_role_policy_attachment" "attach_sagemeker_auto_resume" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = aws_iam_policy.sagemeker_auto_resume.arn
}

#-------------------------------
# IAM Role: Sagemaker Hyperpod for Grafana
#-------------------------------
resource "aws_iam_role_policy_attachment" "attach_prometheus_remote_write" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
}

resource "aws_iam_role_policy_attachment" "attach_cfn_readonly" {
  role       = aws_iam_role.sagemaker_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationReadOnlyAccess"
}
