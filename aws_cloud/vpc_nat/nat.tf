#Define External IP 
resource "aws_eip" "main-nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main-nat-gw" {
  allocation_id = aws_eip.main-nat.id
  subnet_id     = aws_subnet.mainvpc-public-1.id
  depends_on    = [aws_internet_gateway.mainvpc-gw]
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-nat-gw.id
  }

  tags = {
    Name = "main-private"
  }
}

# route associations private
resource "aws_route_table_association" "level-private-1-a" {
  subnet_id      = aws_subnet.mainvpc-private-1.id
  route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.mainvpc-private-2.id
  route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.mainvpc-private-3.id
  route_table_id = aws_route_table.main-private.id
}
