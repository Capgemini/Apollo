variable "name" { }
variable "cidr" { }
variable "public_subnets" { default = "" }
variable "private_subnets" { default = "" }
variable "bastion_instance_id" { }
variable "azs" { }
variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}

# resources
resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.mod.id}"
  }
  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${var.bastion_instance_id}"
  }
  tags {
    Name = "${var.name}-private"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(compact(split(",", var.private_subnets)))}"
  tags {
    Name = "${var.name}-private"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.mod.id}"
  cidr_block        = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(compact(split(",", var.public_subnets)))}"
  tags {
    Name = "${var.name}-public"
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count          = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# outputs
output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}
output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}
output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}
output "vpc_cidr_block" {
  value = "${aws_vpc.mod.cidr_block}"
}
