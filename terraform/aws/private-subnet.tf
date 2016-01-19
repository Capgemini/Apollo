/* Private subnet */
resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${length(split(",", var.availability_zones))}"
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  cidr_block              = "${element(split(",", var.private_subnet_cidr_blocks), count.index)}"
  map_public_ip_on_launch = false
  depends_on              = ["aws_instance.bastion"]
  tags {
    Name = "private"
  }
}

resource "aws_eip" "nat_gateway" {
  count = "${length(split(",", var.availability_zones))}"
  vpc   = true
}

resource "aws_nat_gateway" "gateway" {
  count         = "${length(split(",", var.availability_zones))}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat_gateway.*.id, count.index)}"
}

/* Routing tables for private subnets */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  count  = "${length(split(",", var.availability_zones))}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.gateway.*.id, count.index)}"
  }
  tags {
    Name = "private-${element(split(",", var.availability_zones), count.index)}"
  }
}

/* Associate the routing table to private subnet */
resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.availability_zones))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
