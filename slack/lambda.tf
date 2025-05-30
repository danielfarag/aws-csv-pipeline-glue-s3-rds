
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda.js"
  output_path = "lambda_function_payload.zip"
}



resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "notify_via_slack"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
      REGION            = var.region
      CRAWLER           = var.crawler_name
      JOB               = var.job_name
    }
  }
}