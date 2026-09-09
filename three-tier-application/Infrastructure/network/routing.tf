// igw

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "three-tier-igw"
  })

}

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "three-tier-eip"
  })

}


// nat

resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.frontend_a.id

  tags = merge(var.common_tags, {
    Name = "three-tier-ngw"
  })

}


// FE

// rt

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "three-tier-public-rt"
  })

}

resource "aws_route" "public_internet" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.internet_cidr
  gateway_id             = aws_internet_gateway.main.id

}


// association

resource "aws_route_table_association" "frontend_a" {

  subnet_id      = aws_subnet.frontend_a.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "frontend_b" {

  subnet_id      = aws_subnet.frontend_b.id
  route_table_id = aws_route_table.public.id

}


// BE

// rt

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "three-tier-private-rt"
  })

}

resource "aws_route" "private_internet" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.internet_cidr
  nat_gateway_id         = aws_nat_gateway.main.id

}


// association

resource "aws_route_table_association" "backend_a" {

  subnet_id      = aws_subnet.backend_a.id
  route_table_id = aws_route_table.private.id

}