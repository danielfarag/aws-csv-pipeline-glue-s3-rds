resource "aws_security_group" "etl_rds_security_group" {
  name        = "etl-rds-security-group-minimal"
  description = "Allow inbound MySQL traffic only from my IP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ETL RDS Security Group Minimal"
  }
}