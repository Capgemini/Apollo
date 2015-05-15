/* Default security group */
# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name = "terraform_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Mesos
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
  # Marathon
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Consul UI.
  ingress {
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "apollo-mesos-default-security-group"
  }
}
