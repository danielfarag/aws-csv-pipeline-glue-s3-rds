resource "aws_route_table" "etl_public_rt" {
  vpc_id = aws_vpc.etl_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.etl_igw.id
  }

  tags = {
    Name        = "ETL-Public-Route-Table"
  }
}

resource "aws_route_table_association" "etl_public_rta1" {
  subnet_id      = aws_subnet.etl_public_subnet1.id
  route_table_id = aws_route_table.etl_public_rt.id
}

resource "aws_route_table_association" "etl_public_rta2" {
  subnet_id      = aws_subnet.etl_public_subnet2.id
  route_table_id = aws_route_table.etl_public_rt.id
}
