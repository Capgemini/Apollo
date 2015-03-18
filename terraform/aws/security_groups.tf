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

/* Security group for master instances */
resource "aws_security_group" "master" {
  name        = "master"
  description = "master"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 5050
    to_port     = 5050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* Security group for slave instances */
resource "aws_security_group" "slave" {
  name        = "slave"
  description = "slave"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 5051
    to_port     = 5051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
