output "rds_endpoint" {
  description = "The endpoint of the RDS MySQL database."
  value       = module.database.rds_endpoint
}

output "rds_username" {
  description = "The master username for the RDS MySQL database."
  value       = module.database.rds_username
}