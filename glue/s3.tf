resource "aws_s3_bucket" "bucket" {
  bucket = "iti-glue-users"
  force_destroy = true
  tags = {
    Name = "GLUE"
  }
}

resource "aws_s3_bucket_public_access_block" "etl_s3_project" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "jars/mysql-connector-j-9.3.0.jar"
  source = "${path.module}/mysql-connector-j-9.3.0.jar"
  etag = filemd5("${path.module}/mysql-connector-j-9.3.0.jar")
}
