/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name    = "${var.atlas_artifact.slave}"
  type    = "aws.ami"
  version = "${var.atlas_artifact_version.slave}"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  /*
     We had to hardcode the amis list in variables.tf file creating amis map because terraform doesn't
     support interpolation in the way which could allow us to replaced the region dinamically.
     We need to remember to update the map every time when we build a new artifact on atlas.
     Similar issue related to metada_full is mentioned here:
     https://github.com/hashicorp/terraform/issues/732
  */

  instance_type     = "${var.instance_type.slave}"
  ami               = "${lookup(var.amis, var.region)}"
  count             = "${var.slaves}"
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public", "aws_instance.mesos-master"]
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
  }
  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = "${var.slave_block_device.volume_size}"
    delete_on_termination = true
  }
}

/* Load balancer */
resource "aws_elb" "app" {
  name = "apollo-mesos-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]

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
