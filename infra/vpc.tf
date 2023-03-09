resource "aws_vpc" "code2cloud-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "code2cloud ${var.code2cloudid} VPC"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "code2cloud-internet-gateway" {
  vpc_id = "${aws_vpc.code2cloud-vpc.id}"
  tags = {
      Name = "code2cloud ${var.code2cloudid} Internet Gateway"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnets
resource "aws_subnet" "code2cloud-public-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block = "10.10.10.0/24"
  vpc_id = "${aws_vpc.code2cloud-vpc.id}"
  tags = {
      Name = "code2cloud ${var.code2cloudid} Public Subnet #1"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
resource "aws_subnet" "code2cloud-public-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block = "10.10.20.0/24"
  vpc_id = "${aws_vpc.code2cloud-vpc.id}"
  tags = {
      Name = "code2cloud ${var.code2cloudid} Public Subnet #2"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnet Routing Table
resource "aws_route_table" "code2cloud-public-subnet-route-table" {
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.code2cloud-internet-gateway.id}"
  }
  vpc_id = "${aws_vpc.code2cloud-vpc.id}"
  tags = {
      Name = "code2cloud ${var.code2cloudid} Route Table for Public Subnet"
      Stack = "${var.stack-name}"
      Scenario = "${var.scenario-name}"
  }
}
#Public Subnets Routing Associations
resource "aws_route_table_association" "code2cloud-public-subnet-1-route-association" {
  subnet_id = "${aws_subnet.code2cloud-public-subnet-1.id}"
  route_table_id = "${aws_route_table.code2cloud-public-subnet-route-table.id}"
}
resource "aws_route_table_association" "code2cloud-public-subnet-2-route-association" {
  subnet_id = "${aws_subnet.code2cloud-public-subnet-2.id}"
  route_table_id = "${aws_route_table.code2cloud-public-subnet-route-table.id}"
}