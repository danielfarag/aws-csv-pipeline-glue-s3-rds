output "public_subnets" {
  value=[
    aws_subnet.etl_public_subnet1,
    aws_subnet.etl_public_subnet2
  ]
}

output "vpc_id" {
  value= aws_vpc.etl_vpc.id
}