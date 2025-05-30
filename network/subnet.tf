data "aws_availability_zones" "zones" {
    state = "available"
}

resource "aws_subnet" "etl_public_subnet1" {
  vpc_id                  = aws_vpc.etl_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true 
  availability_zone = data.aws_availability_zones.zones.names[1]
  tags = {
    Name        = "ETL-Public-Subnet1"
  }
}
resource "aws_subnet" "etl_public_subnet2" {
  vpc_id                  = aws_vpc.etl_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true 
  availability_zone = data.aws_availability_zones.zones.names[2]

  tags = {
    Name        = "ETL-Public-Subnet2"
  }
}