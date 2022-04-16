resource "aws_security_group" "db_instance" {
  description = "security-group--db-instance"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
  }

  name = "security-group--db-instance"

  tags = {
    Env  = "production"
    Name = "security-group--db-instance"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_db_subnet_group" "default" {
  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.private__a.id,
    aws_subnet.private__b.id
  ]

  tags = {
    Env  = "production"
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  backup_window        = "03:00-04:00"
  db_subnet_group_name = "db-subnet-group"
  depends_on           = [aws_db_subnet_group.default]
  engine_version       = "14.2"
  engine               = "postgres"
  identifier           = "production"
  instance_class       = "db.t3.micro"
  maintenance_window   = "sun:08:00-sun:09:00"
  db_name              = var.rds_db_name
  parameter_group_name = "default.postgres14"
  password             = var.rds_password
  skip_final_snapshot  = true
  username             = var.rds_username
  publicly_accessible = true
}

output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}
output "db_address" {
  value = aws_db_instance.default.address
}