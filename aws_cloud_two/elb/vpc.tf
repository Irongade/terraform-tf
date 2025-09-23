resource "aws_vpc" "mainvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support = "true"
  enable_dns_hostnames = "true"
    
  tags = {
    Name = "main"
  }
}


# Public Subnets in Custom VPC
resource "aws_subnet" "mainvpc-public-1" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "mainvpc-public-1"
  }
}

resource "aws_subnet" "mainvpc-public-2" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "mainvpc-public-2"
  }
}

resource "aws_subnet" "mainvpc-public-3" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-2c"

  tags = {
    Name = "mainvpc-public-3"
  }
}


# Private Subnets in Custom VPC
resource "aws_subnet" "mainvpc-private-1" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "mainvpc-private-1"
  }
}

resource "aws_subnet" "mainvpc-private-2" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "mainvpc-private-2"
  }
}

resource "aws_subnet" "mainvpc-private-3" {
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-2c"

  tags = {
    Name = "mainvpc-private-3"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "mainvpc-gw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name = "mainvpc-gw"
  }
}


#Routing Table for the Custom VPC
resource "aws_route_table" "mainvpc-public" {
  vpc_id = aws_vpc.mainvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mainvpc-gw.id
  }

  tags = {
    Name = "mainvpc-public-1"
  }
}

resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.mainvpc-public-1.id
  route_table_id = aws_route_table.mainvpc-public.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.mainvpc-public-2.id
  route_table_id = aws_route_table.mainvpc-public.id
}

resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = aws_subnet.mainvpc-public-3.id
  route_table_id = aws_route_table.mainvpc-public.id
}
