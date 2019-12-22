#--------------------------------------------------------------
# CloudWatch Event Settings
#--------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "main" {
  name = "codepipeline-notifications-rule"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Stage Execution State Change"
  ],
  "detail": {
    "state": ["STARTED", "SUCCEEDED", "FAILED"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "main" {
  rule      = "${aws_cloudwatch_event_rule.main.name}"
  target_id = "SendToSNS"
  arn       = "${aws_sns_topic.main.arn}"
}

#--------------------------------------------------------------
# AWS SNS TOPIC
#--------------------------------------------------------------
resource "aws_sns_topic" "main" {
  name         = "codepipeline-notifications"
  display_name = "CodePipeline notifications"
}

#--------------------------------------------------------------
# AWS Lambda FUNCTION
#--------------------------------------------------------------
resource "aws_lambda_function" "main" {
  handler          = "index.handler"
  runtime          = "nodejs10.x"
  function_name    = "codepipeline-notifications-function"
  filename         = "${path.module}/functions/notifications/dist.zip"
  role             = "${aws_iam_role.lambda.arn}"
  source_code_hash = "${filebase64sha256("${path.module}/functions/notifications/dist.zip")}"

  environment {
    variables = {
      SLACK_WEBHOOK_URL = "${var.slack_webhook}"
    }
  }
}

resource "aws_lambda_permission" "main" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
  function_name = "${aws_lambda_function.main.function_name}"
  source_arn    = "${aws_sns_topic.main.arn}"
}

resource "aws_sns_topic_subscription" "main" {
  topic_arn = "${aws_sns_topic.main.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.main.arn}"
}
