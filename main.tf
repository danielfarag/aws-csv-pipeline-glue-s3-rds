module "network" {
  source = "./network"
}

module "database" {
  source = "./database"
  public_subnets = module.network.public_subnets[*].id
  vpc_id = module.network.vpc_id
}


module "glue" {
  source = "./glue"
  public_subnets = module.network.public_subnets
  db_name = module.database.rds_username
  db_password = module.database.rds_password
  rds_sg = module.database.rds_sg
  db_endpoint = module.database.rds_endpoint
}

module "slack" {
  source = "./slack"
  bucket = module.glue.s3_bucket_name
  slack_webhook_url = var.slack_webhook_url
  region = var.region
  crawler_name = module.glue.catalog_crawler_name
  job_name = module.glue.job_name
}