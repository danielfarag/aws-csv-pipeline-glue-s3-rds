resource "aws_internet_gateway" "etl_igw" {
  vpc_id = aws_vpc.etl_vpc.id

  tags = {
    Name        = "ETL-IGW"
  }
}