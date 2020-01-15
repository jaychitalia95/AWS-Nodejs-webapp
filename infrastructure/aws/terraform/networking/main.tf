
/*
# tf_aws_module_name

A terraform module to describe a thing
*/

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile = "validityhq"
}

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy="default"
}

resource "aws_subnet" "primary" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "primary-jchitalia"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "secondary-jchitalia"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "InternetGateway-jchitalia"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rtb-jchitalia"
  }
}

resource "aws_route_table_association" "subnetprimary" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table_association" "subnetsecondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.rtb.id
}
