output "rds_endpoint" {
  value       = aws_db_instance.etl_mysql_db.address
}

output "rds_username" {
  value       = aws_db_instance.etl_mysql_db.username
}

output "rds_password" {
  value       = aws_db_instance.etl_mysql_db.password
}

output "rds_sg" {
  value = aws_security_group.etl_rds_security_group.id
}
