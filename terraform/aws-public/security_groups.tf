/* Default security group */
resource "aws_security_group" "default" {
  name = "default-apollo-mesos"
  description = "Default security group that allows all traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "apollo-mesos-default-security-group"
  }
}
