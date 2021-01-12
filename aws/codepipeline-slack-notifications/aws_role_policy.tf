#--------------------------------------------------------------
# CodeBuild Role
#--------------------------------------------------------------
data "template_file" "codebuild_assume_role" {
  template = "${file("./policies/codepipeline/codebuild_assume_role.json.tpl")}"
}
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"
  assume_role_policy = "${data.template_file.codebuild_assume_role.rendered}"
}

data "template_file" "codebuild_policy" {
  template = "${file("./policies/codepipeline/codebuild_policy.json.tpl")}"

  vars = {
    account_id = "${var.account_id}"
    region = "${var.region}"
    codebuild_name = "${var.codebuild_name}"
    bucket_name = "${var.artifact_bucket_name}"
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = "${aws_iam_role.codebuild_role.name}"
  policy = "${data.template_file.codebuild_policy.rendered}"
}

#--------------------------------------------------------------
# CodePipeline Role
#--------------------------------------------------------------
data "template_file" "codepipeline_assume_role" {
  template = "${file("./policies/codepipeline/codepipeline_assume_role.json.tpl")}"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"
  assume_role_policy = "${data.template_file.codepipeline_assume_role.rendered}"
}

data "template_file" "codepipeline_policy" {
  template = "${file("./policies/codepipeline/codepipeline_policy.json.tpl")}"
}
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  role = "${aws_iam_role.codepipeline_role.id}"
  policy = "${data.template_file.codepipeline_policy.rendered}"
}

data "template_file" "codepipeline_s3_policy" {
  template = "${file("./policies/codepipeline/codepipeline_s3_policy.json.tpl")}"
  vars = {
    bucket_name = "${var.artifact_bucket_name}"
  }
}
resource "aws_s3_bucket_policy" "codepipeline_s3_policy" {
  bucket = "${aws_s3_bucket.artifact.id}"
  policy = "${data.template_file.codepipeline_s3_policy.rendered}"
}

#--------------------------------------------------------------
# AWS SNS TOPIC POLICY
#--------------------------------------------------------------
resource "aws_sns_topic_policy" "main" {
  arn = "${aws_sns_topic.main.arn}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "AWSEvents_smebiz-codepipeline-events_SendToSNS",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.main.arn}"
    }
  ]
}
EOF
}

#--------------------------------------------------------------
# AWS Lambda FUNCTION IAM ROLE
#--------------------------------------------------------------
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "lambda-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}


data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  name   = "lambda-policy"
  role   = "${aws_iam_role.lambda.id}"
  policy = "${data.aws_iam_policy_document.lambda_permissions.json}"
}