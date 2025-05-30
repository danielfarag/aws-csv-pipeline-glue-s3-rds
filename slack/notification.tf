resource "aws_lambda_permission" "allow_invokers" {
  for_each = {
    s3_bucket = {
      principal  = "s3.amazonaws.com"
      source_arn = var.bucket.arn
      statement_id = "AllowExecutionFromS3Bucket"
    },
    events_rule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.glue_crawler_succeeded_rule.arn
      statement_id = "AllowExecutionFromCloudWatchEvents"
    },
  }
  statement_id  = each.value.statement_id
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "etl/"
    # filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_invokers]
}