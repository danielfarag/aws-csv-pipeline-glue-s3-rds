
resource "aws_db_subnet_group" "etl_db_subnet_group" {
  name       = "etl-db-subnet-group-minimal"
  subnet_ids = var.public_subnets

  tags = {
    Name        = "ETL DB Subnet Group Minimal"
  }
}



resource "aws_db_instance" "etl_mysql_db" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true 

  db_subnet_group_name = aws_db_subnet_group.etl_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.etl_rds_security_group.id]

  tags = {
    Name        = "ETL MySQL DB Minimal"
  }
}

resource "null_resource" "run_sql_script" {
  provisioner "local-exec" {
    command = <<EOT
    mysql -h ${aws_db_instance.etl_mysql_db.address} \
          -u ${var.db_username} -p${var.db_password} ${var.db_name} < ${path.module}/init.sql
    EOT
  }

  depends_on = [aws_db_instance.etl_mysql_db]
}
