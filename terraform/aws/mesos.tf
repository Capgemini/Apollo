resource "atlas_artifact" "mesos" {
  name = "capgemini/mesos-0.21.0_ubuntu-14.04_amd64"
  type = "aws.ami"
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "mesos-sg" {
  name = "mesos-sg"
  description = "Mesos security group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5050
    to_port = 5050
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5051
    to_port = 5051
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 2181
    to_port = 2181
    protocol = "tcp"
    self = true
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Default mesos-slave port range
  ingress {
    from_port = 31000
    to_port = 32000
    protocol = "tcp"
    self = true
    cidr_blocks = ["0.0.0.0/0"]
  }
}


