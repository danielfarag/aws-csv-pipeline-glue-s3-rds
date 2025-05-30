resource "aws_cloudwatch_event_rule" "glue_crawler_succeeded_rule" {
  name        = "glue-crawler-succeeded-event-rule"
  description = "Triggers when a Glue Crawler finishes with SUCCEEDED state"

  event_pattern = jsonencode({
    "source": ["aws.glue"],
    "detail-type": ["Glue Crawler State Change"],
  })
}

data "aws_iam_policy_document" "eventbridge_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eventbridge_target_role" {
  name               = "eventbridge-target-invoke-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_assume_role_policy.json
}

data "aws_iam_policy_document" "eventbridge_target_invoke_lambda_policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.test_lambda.arn] 
  }
}

resource "aws_iam_policy" "eventbridge_target_invoke_lambda_policy_aws" {
  policy      = data.aws_iam_policy_document.eventbridge_target_invoke_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "eventbridge_target_role_invoke_lambda_attachment" {
  role       = aws_iam_role.eventbridge_target_role.name
  policy_arn = aws_iam_policy.eventbridge_target_invoke_lambda_policy_aws.arn
}



resource "aws_cloudwatch_event_target" "invoke_lambda_on_crawler_succeeded" {
  rule      = aws_cloudwatch_event_rule.glue_crawler_succeeded_rule.name
  role_arn  = aws_iam_role.eventbridge_target_role.arn
  target_id = "my-crawler-success-lambda-target"
  arn       = aws_lambda_function.test_lambda.arn
}