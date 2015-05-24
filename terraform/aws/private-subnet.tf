/* Private subnet */
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${lookup(var.cidr_blocks, concat("zone", count.index))}"
  availability_zone       = "${lookup(var.zones, concat("zone", count.index))}"
  count                   = "${var.masters}"
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
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags {
    Name = "private"
  }
}

/* Associate the routing table to private subnet */
resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
  count          = "${var.masters}"
}