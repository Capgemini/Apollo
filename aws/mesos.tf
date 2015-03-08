resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

module "mesos_ceph" {
  source                   = "github.com/riywo/mesos-ceph/terraform"
  vpc_id                   = "${aws_vpc.default.id}"
  key_name                 = "${var.key_name}"
  key_path                 = "${var.key_path}"
  subnet_availability_zone = "us-east-1e"
  subnet_cidr_block        = "10.0.1.0/24"
  master1_ip               = "10.0.1.11"
  master2_ip               = "10.0.1.12"
  master3_ip               = "10.0.1.13"
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
}

resource "aws_instance" "mesos-master" {
  instance_type = "${consul_keys.input.var.size}"
  ami = "${lookup(var.amis, var.region)}"
  count = 1
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.mesos-sg.name}"]
  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }
  provisioner "remote-exec" {
    scripts = [
      "../files/install-common.sh",
      "../files/setup-master.sh"
    ]
  }
}

resource "aws_route53_record" "mesos-master" {
   zone_id = "${var.zone_id}"
   name = "${var.mesos_dns}"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.mesos-master.public_ip}"]
}

resource "aws_instance" "mesos-slave" {
  instance_type = "${consul_keys.input.var.size}"
  ami = "${lookup(var.amis, var.region)}"
  count = 1
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.mesos-sg.name}"]
  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${aws_instance.mesos-master.private_ip} > /tmp/zk_master"
    ]
  }
  provisioner "remote-exec" {
    scripts = [
      "../files/install-common.sh",
      "../files/setup-slave.sh"
    ]
  }
}

# Setup a key in Consul to provide inputs
resource "consul_keys" "input" {
    key {
        name = "size"
        path = "tf_test/size"
        default = "m1.small"
    }
}

# Setup a key in Consul to store the instance id and
# the DNS name of the instance
resource "consul_keys" "test" {
    key {
        name = "id"
        path = "tf_test/id"
        value = "${aws_instance.test.id}"
        delete = true
    }
    key {
        name = "address"
        path = "tf_test/public_dns"
        value = "${aws_instance.test.public_dns}"
        delete = true
    }
}


