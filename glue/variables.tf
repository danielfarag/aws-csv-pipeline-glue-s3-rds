variable "db_endpoint" {
  type = string
}


variable "db_name" {
  type = string
}

variable "db_password" {
  type = string
}


variable "public_subnets" {
  type = list(object({
    id = string 
    availability_zone = string
  }))
}

variable "rds_sg" {
  type = string
}