/* Private subnet */
resource "aws_subnet" "az1" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.az1_subnet_cidr_block}"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false
  depends_on              = ["aws_instance.nat"]
  tags {
    Name = "private"
  }
}

resource "aws_subnet" "az2" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.az2_subnet_cidr_block}"
  availability_zone       = "${var.subnet_availability_zone}"
  map_public_ip_on_launch = false
  depends_on              = ["aws_instance.nat"]
  tags {
    Name = "private"
  }
}

resource "aws_subnet" "az3" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.az3_subnet_cidr_block}"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = false
  depends_on              = ["aws_instance.nat"]
  tags {
    Name = "private"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags {
    Name = "private"
  }
}

/* Associate the routing table to private subnet */
resource "aws_route_table_association" "az1" {
  subnet_id = "${aws_subnet.az1.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "az2" {
  subnet_id = "${aws_subnet.az2.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "az3" {
  subnet_id = "${aws_subnet.az3.id}"
  route_table_id = "${aws_route_table.private.id}"
}
