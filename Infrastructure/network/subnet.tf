data "aws_availability_zones" "available" {

  state = "available"

}

resource "aws_subnet" "frontend_a" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.common_tags, {
    Name = "frontend-subnet-a"
  })

}

resource "aws_subnet" "frontend_b" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.frontend_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.common_tags, {
    Name = "frontend-subnet-b"
  })

}

resource "aws_subnet" "backend_a" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.backend_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.common_tags, {
    Name = "backend-subnet-a"
  })

}

resource "aws_subnet" "db_a" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.common_tags, {
    Name = "db-subnet-a"
  })

}

resource "aws_subnet" "db_b" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.common_tags, {
    Name = "db-subnet-b"
  })

}

resource "aws_db_subnet_group" "database" {

  name = "three-tier-db-subnet-group"

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]

  tags = merge(var.common_tags, {
    Name = "three-tier-db-subnet-group"
  })

}