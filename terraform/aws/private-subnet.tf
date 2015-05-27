/* Private subnet */
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.private_subnet_cidr_block}"
  availability_zone       = "${var.subnet_availability_zone}"
  map_public_ip_on_launch = false
  depends_on              = ["aws_instance.bastion"]
  tags {
    Name = "private"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.bastion.id}"
  }
  tags {
    Name = "private"
  }
}

/* Associate the routing table to private subnet */
resource "aws_route_table_association" "private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}
