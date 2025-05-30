variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}



variable "db_username" {
  type = string
  default = "foo"
}

variable "db_password" {
  type = string
  default = "foobarbaz"
}

variable "db_name" {
  type = string
  default = "mydb"
}