
output "s3_bucket_name" {
  description = "bucket name"
  value = aws_s3_bucket.bucket
}
output "catalog_crawler_name" {
  value = aws_glue_crawler.etl_data_crawler.name
}
output "job_name" {
  value = aws_glue_job.user_data_etl_job.name
}