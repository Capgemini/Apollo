variable "security_group_name" { default = "default-apollo-mesos" }
variable "vpc_id" {}
variable "source_cidr_block" { default = "0.0.0.0/0" }

# Security group that allows all traffic
resource "aws_security_group" "default" {
  name        = "${var.security_group_name}"
  description = "Default security group that allows all traffic"
  vpc_id      = "${var.vpc_id}"

  # Allows inbound and outbound traffic from all instances in the VPC.
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  # Allows all inbound traffic
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.source_cidr_block}"]
  }

  # Allows all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.source_cidr_block}"]
  }
  tags {
    Name = "apollo-default-sg"
  }
}

# output variables
output "security_group_id" {
  value = "${aws_security_group.default.id}"
}
