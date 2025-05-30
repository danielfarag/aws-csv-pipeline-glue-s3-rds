
resource "aws_glue_connection" "rds_mysql_connection" {
  name        = "your-rds-mysql-connection"
  description = "Connection to RDS MySQL database"
  connection_type = "JDBC"
  connection_properties = {
    "JDBC_CONNECTION_URL" = "jdbc:mysql://${var.db_endpoint}:3306/${var.db_name}"
    "USERNAME"            = var.db_name
    "PASSWORD"            = var.db_password 
  }
  physical_connection_requirements {
    subnet_id        = var.public_subnets[0].id
    security_group_id_list = [var.rds_sg] 
    availability_zone = var.public_subnets[0].availability_zone
  }

  tags = {
    Name        = "RDS MySQL Connection"
    Project     = "MyETLProject"
  }
}


resource "aws_glue_job" "user_data_etl_job" {
  name     = "user_data_etl_job"
  role_arn = aws_iam_role.glue_service_role.arn
  command {
    script_location = "s3://${aws_s3_bucket.bucket.id}/glue_scripts/glue_user.py"
    python_version  = "3" 
  }
  glue_version = "4.0" 
  number_of_workers = 2 
  worker_type = "G.1X" 
  timeout = 60 

  
  default_arguments = {
    "--TempDir" = "s3://${aws_s3_bucket.bucket.id}/glue_temp/"
    "--job-bookmark-option" = "job-bookmark-disable"
    "--enable-continuous-logging" = "true"
    "--enable-metrics" = "true"
    "--extra-jars" = "s3://${aws_s3_bucket.bucket.id}/jars/mysql-connector-j-9.3.0.jar" 

  }

  tags = {
    Name        = "User Data ETL Job"
    Project     = "MyETLProject"
  }
}
