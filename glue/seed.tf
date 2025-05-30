resource "aws_s3_object" "glue_user_etl_script" {
  bucket = aws_s3_bucket.bucket.id 
  key    = "glue_scripts/glue_user.py"   
  source = "${path.module}/glue_user.py"               
  etag   = filemd5("${path.module}/glue_user.py")       
}