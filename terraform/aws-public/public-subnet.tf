/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.default.id}"
}

/* Public subnet */
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${var.subnet_availability_zone}"
  cidr_block              = "${var.public_subnet_cidr_block}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.public"]
  tags {
    Name = "public"
  }
}

/* Routing table for public subnet */
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

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}
