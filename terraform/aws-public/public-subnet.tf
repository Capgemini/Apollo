# Internet gateway for the public subnet
resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.default.id}"
}

# Public subnet
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.default.id}"
  count                   = "${length(split(",", var.availability_zones))}"
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.public"]
  tags {
    Name = "public"
  }
}

# Routing table for public subnet
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }
  tags {
    Name = "main"
  }
}

resource "aws_main_route_table_association" "public" {
  vpc_id         = "${aws_vpc.default.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
