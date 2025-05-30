
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "aws_iam_policy_document" "lambda_logging_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "glue:StartCrawler",
      "glue:StartJobRun",
      "glue:GetCrawler"
    ]
    resources = [
      "*" 
    ]
    effect = "Allow"
  }
}


resource "aws_iam_policy" "lambda_logging_policy_aws" {
  name        = "my-lambda-logging-policy"
  description = "IAM policy for Lambda to write logs to CloudWatch"
  policy      = data.aws_iam_policy_document.lambda_logging_policy.json
}


resource "aws_iam_role_policy_attachment" "lambda_logging_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_policy_aws.arn
}
