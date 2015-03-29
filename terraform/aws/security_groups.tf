/* Default security group */
resource "aws_security_group" "default" {
  name = "default-capgemini-mesos"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags {
    Name = "capgemini-mesos-default-vpc"
  }
}

/* Security group for the nat server */
resource "aws_security_group" "nat" {
  name = "nat-capgemini-mesos"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 1194
    to_port   = 1194
    protocol  = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "nat-capgemini-mesos"
  }
}

resource "aws_security_group" "loadbalancer" {
  name = "loadbalancer"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "loadbalancer-capgemini-mesos"
  }
}
