/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name    = "${var.atlas_artifact.slave}"
  version = "26"
  type    = "aws.ami"
}

resource "atlas_artifact" "mesos-slave-b" {
  name    = "${var.atlas_artifact.slave}"
  version = "${var.atlas_artifact_version.slave}"
  type    = "aws.ami"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type     = "m4.large"
  /* waiting for https://github.com/hashicorp/terraform/issues/2731 so we don't have to hard-code the region */
  ami               = "${atlas_artifact.mesos-slave.metadata_full.ami_id}"
  count             = 0
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public", "aws_instance.mesos-master"]
  root_block_device {
    volume_size           = "${var.slave_block_device.volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "apollo-mesos-slave-docker-${count.index}"
    role = "mesos_slaves_docker"
    monitoring = "datadog"
  }
}

resource "aws_instance" "mesos-slave-b" {
  instance_type     = "${var.instance_type.slave}"
  ami               = "${atlas_artifact.mesos-slave-b.metadata_full.ami_id}"
  count             = "${var.slaves}"
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public", "aws_instance.mesos-master"]
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
    monitoring = "datadog"
  }
  root_block_device {
    volume_size           = "${var.slave_block_device.volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }
  ebs_block_device {
    device_name = "/dev/sde"
    volume_size = "${var.slave_block_device.volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }
  connection {
    user         = "ubuntu"
    key_file     = "${var.private_key_file}"
    bastion_host = "${aws_eip.bastion.public_ip}"
    agent        = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t ext4 -i 4096 -b 4096 -I 128 /dev/xvde",
      "sudo mount /dev/xvde /var/lib/docker/overlay",
      "echo '/dev/xvde	/var/lib/docker/overlay	ext4	defaults,nofail,nobootwait	0	2' | sudo tee -a /etc/fstab",
    ]
  }
}

/* Load balancer */
resource "aws_elb" "app" {
  name = "apollo-mesos-elb-${var.cluster_name}"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]

  access_logs {
    bucket = "${aws_s3_bucket.state.id}"
  }

  listener {
    instance_port = 443 
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
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
    interval            = 10
  }

  tags {
    monitoring = "datadog"
  }

  instances = ["${aws_instance.mesos-slave-b.*.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 60
}

resource "aws_proxy_protocol_policy" "http" {
  load_balancer = "${aws_elb.app.name}"
  instance_ports = ["80"]
}
