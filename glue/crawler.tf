resource "aws_glue_catalog_database" "glue_users_catalog" {
  name = "users_catalog"
}


resource "aws_glue_crawler" "etl_data_crawler" {
  database_name = aws_glue_catalog_database.glue_users_catalog.name
  name          = "users_catalog_crawler"
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.bucket.id}/etl/users"
  }
}


