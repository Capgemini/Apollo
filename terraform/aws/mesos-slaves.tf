/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name = "${var.atlas_artifact.slave}"
  type = "aws.ami"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.instance_type.slave}"
  ami               = "${replace(atlas_artifact.mesos-master.id, concat(var.region, ":"), "")}"
  count             = "${var.slaves}"
  key_name          = "${var.key_name}"
  source_dest_check = false
  subnet_id         = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public", "aws_instance.mesos-master"]
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
  }
#  ebs_block_device {
#    device_name           = "/dev/sdb"
#    volume_size           = "${var.slave_block_device.volume_size}"
#    delete_on_termination = true
#  }
}

/* Load balancer */
resource "aws_elb" "app" {
  name = "apollo-mesos-elb"
  subnets = ["${aws_subnet.public.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_certificate_arn}"
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:34180/haproxy_status"
    interval            = 30
  }

  instances = ["${aws_instance.mesos-slave.*.id}"]
  cross_zone_load_balancing = true
}

resource "aws_proxy_protocol_policy" "http" {
  load_balancer = "${aws_elb.app.name}"
  instance_ports = ["80"]
}