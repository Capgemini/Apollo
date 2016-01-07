# Private subnet
resource "aws_subnet" "private" {
  vpc_id                  = "${module.vpc.vpc_id}"
  count                   = "${length(split(",", var.availability_zones))}"
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  cidr_block              = "10.0.${count.index+1}.0/24"
  map_public_ip_on_launch = false
  depends_on              = ["aws_instance.bastion"]
  tags {
    Name = "private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${module.vpc.vpc_id}"
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.bastion.id}"
  }
  tags {
    Name = "private"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", var.availability_zones))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
