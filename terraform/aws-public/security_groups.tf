/* Default security group */
resource "aws_security_group" "default" {
  name = "default-apollo-mesos"
  description = "Default security group that allows all traffic"

  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "apollo-mesos-default-security-group"
  }
}
