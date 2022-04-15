resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Env  = "production"
    Name = "vpc"
  }
}

resource "aws_subnet" "public__a" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Env  = "production"
    Name = "public-us-east-1a-blog"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "public__b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Env  = "production"
    Name = "public-us-east-1b-blog"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "private__a" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = false

  tags = {
    Env  = "production"
    Name = "private-us-east-1a"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "private__b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = false

  tags = {
    Env  = "production"
    Name = "private-us-east-1b"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Env  = "production"
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Env  = "production"
    Name = "route-table-public"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "private" {
  tags = {
    Env  = "production"
    Name = "route-table-private"
  }

  vpc_id = aws_vpc.default.id
}

resource "aws_route_table_association" "public__a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public__a.id
}

resource "aws_route_table_association" "public__b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public__b.id
}

resource "aws_route_table_association" "private__a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private__a.id
}

resource "aws_route_table_association" "private__b" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private__b.id
}
